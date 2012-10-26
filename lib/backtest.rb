require 'historic_data'
require 'knn'
require 'classifer'

class Backtest
  attr_reader :index, :components, :train, :test
  
  def initialize(index, components)
    @index, @components = index.upcase, components.map(&:upcase)
    tickers = [index,components].flatten
    @train = HistoricData.request 2, 3, tickers
    @test = HistoricData.request 1, 1, tickers
  end
  
  def positions
    @positions ||= begin
      knn = KNearestNeighbours.new Classifer.new(index, train).trained_examples
      test_set = Classifer.new(index, test).trained_examples
      
      test_set.inject([]) do |positions, bar|
        example = Hash[ bar.find_all {|k,_| k != :classification } ]
        positions << [ bar[:classification], knn.classify(example) ]
      end
    end
  end
  
  def report
    Report.new(positions).summary
  end
end

class Report
  attr_reader :positions
  
  def initialize(positions)
    @positions = positions
  end
  
  def summary
    puts "Correct positions:   %s"    % correct_positions
    puts "Incorrect positions: %s"    % incorrect_positions
    puts "Missed positions:    %s"    % missed_positions
    puts "Accuracy:            %.2f%" % accuracy
  end
  
  def positions_taken
    positions.find_all &:last
  end
  
  def missed_positions
    positions.find_all(&:first).size - positions_taken.size
  end
  
  def correct_positions
    positions_taken.find_all {|e| e.first == e.last }.size
  end
  
  def incorrect_positions
    positions_taken.size - correct_positions
  end
  
  def accuracy
    ((correct_positions.to_f/positions_taken.size) * 100)
  end
end
