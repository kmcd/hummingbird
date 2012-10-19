require 'historic_data'
require 'knn'
require 'classifer'

class Backtest
  attr_reader :index, :components, :train, :test
  
  def initialize(index, components)
    @index, @components = index.upcase, components.map(&:upcase)
    tickers = [index,components].flatten
    @train = request_historic_data 2, 3, tickers
    @test = request_historic_data 1, 1, tickers
  end
  
  def request_historic_data(days, previous, tickers, wait=10)
    end_day = days.days.ago.end_of_day.strftime("%Y%m%d %H:%M:%S")
    hd = HistoricData.new
    hd.request tickers, end_day, previous, wait
    hd.disconnect
    hd.historic_data
  end # TODO: load data from yaml/redis if available

  def positions
    @positions ||= begin
      knn = KNearestNeighbours.new Classifer.new(index, train).trained_examples
      results = Classifer.new(index, test).trained_examples
      
      results.inject([]) do |positions, result|
        classification = result[:classification]
        example = Hash[ result.find_all {|k,_| k != :classification } ]
        test_classification = knn.classify example
        positions << [classification, test_classification]
      end
    end
  end
  
  def report
    positions_taken = positions.find_all &:last
    missed_positions = positions_taken.size - positions.find_all(&:first).size
    correct_positions = positions_taken.find_all {|e| e.first == e.last }.size
    incorrect_positions = positions_taken.size - correct_positions
    accuracy = ((correct_positions.to_f/positions_taken.size) * 100)
    
    puts "Correct positions:   %s"    % correct_positions
    puts "Incorrect positions: %s"    % incorrect_positions
    puts "Missed positions:    %s"    % missed_positions
    puts "Accuracy:            %.2f%" % accuracy
  end
end
