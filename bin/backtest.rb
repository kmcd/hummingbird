$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'hummingbird'
require 'historic_data'

# TODO: take index, components, day range from script args
# TODO: loaded cached data from YAML if available

# Fetch data: previous 4 - 2 days 
previous = 3
end_day = 2.days.ago.end_of_day.strftime("%Y%m%d %H:%M:%S")

train = HistoricData.new
train.request 'SQQQ', end_day, previous
train.request %w[ AAPL MSFT GOOG ORCL INTC AMZN QCOM CSCO CMCSA AMGN ], 
  end_day, previous
  
# TODO: wait for train.historic_data.keys
knn = KNearestNeighbours.new Classifer.new(train.historic_data, 'SQQQ').trained_examples

# Fetch data: previous 1 days
previous = 1
end_day = 1.days.ago.end_of_day.strftime("%Y%m%d %H:%M:%S")

test = HistoricData.new
test.request 'SQQQ', end_day, previous

# TODO: wait for test.historic_data.keys
test.request %w[ AAPL MSFT GOOG ORCL INTC AMZN QCOM CSCO CMCSA AMGN ], 
  end_day, previous
  
results = Classifer.new(test.historic_data, 'SQQQ').trained_examples

positions = results.inject([]) do |positions, result|
  classification = result[:classification]
  example = Hash[ result.find_all {|k,_| k != :classification } ]
  test_classification = knn.classify example
  positions << [classification, test_classification]
end

positions_taken = errors.find_all &:last
missed_positions = positions - positions_taken
correct_positions = positions_taken.find_all {|e| e.first == e.last }.size
incorrect_positions = positions_taken.size - correct_positions

# TODO: tabularise output
puts "Correct positions: %s" % correct_positions
puts "Incorrect positions: %s" % incorrect_positions
puts "Missed positions: %s" % missed_positions
