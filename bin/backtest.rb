$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'hummingbird'

# Usage ./bin/backtest.rb -index=QQQ, -components=AAPL,MSFT,GOOG,ORCL ...
index = $index.upcase
components = $components.split(',').map &:upcase

def request_historic_data(days, previous, tickers, wait=10)
  end_day = days.days.ago.end_of_day.strftime("%Y%m%d %H:%M:%S")
  
  # TODO: load previously retrieved data from yaml
  # data/qqq_2012_01_01.yml
  hd = HistoricData.new
  hd.request tickers, end_day, previous, wait
  hd.disconnect
  hd
end

train = request_historic_data 2, 3, components
knn = KNearestNeighbours.new Classifer.new(index, train.historic_data).
  trained_examples

test = request_historic_data 1, 1, index
results = Classifer.new(index, test.historic_data).trained_examples

positions = results.inject([]) do |positions, result|
  classification = result[:classification]
  example = Hash[ result.find_all {|k,_| k != :classification } ]
  test_classification = knn.classify example
  positions << [classification, test_classification]
end

positions_taken = positions.find_all &:last
missed_positions = positions - positions_taken
correct_positions = positions_taken.find_all {|e| e.first == e.last }.size
incorrect_positions = positions_taken.size - correct_positions

# TODO: tabularise output
puts "Correct positions: %s" % correct_positions
puts "Incorrect positions: %s" % incorrect_positions
puts "Missed positions: %s" % missed_positions
