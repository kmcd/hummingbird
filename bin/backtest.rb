$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'hummingbird'
require 'historic_data'

# TODO: take index, components, day range from script args
# TODO: load previously retrieved data from yaml

def request_historic_data(days, previous)
  ndx10 = %w[ AAPL MSFT GOOG ORCL INTC AMZN QCOM CSCO CMCSA AMGN ]
  end_day = days.days.ago.end_of_day.strftime("%Y%m%d %H:%M:%S")
  
  hd = HistoricData.new
  hd.request 'SQQQ', end_day, previous
  hd.request ndx10, end_day, previous
  
  print "Waiting for historic data "
  while hd.historic_data.keys.size < ndx10.size + 1
    print '.' ; sleep 1
  end
  puts
  hd
end

train = request_historic_data 2, 3
knn = KNearestNeighbours.new Classifer.new('SQQQ', train.historic_data).
  trained_examples

test = request_historic_data 1, 1
results = Classifer.new('SQQQ', test.historic_data).trained_examples

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
