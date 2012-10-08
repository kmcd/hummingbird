$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'hummingbird'
require 'historic_data'

# Fetch data: previous 4 - 2 days (load from YAML instead)
previous = 3
end_day = 2.days.ago.end_of_day.strftime("%Y%m%d %H:%M:%S")

train = HistoricData.new
train.request 'SQQQ', end_day, previous
train.request %w[ AAPL MSFT GOOG ORCL INTC AMZN QCOM CSCO CMCSA AMGN ], 
  end_day, previous
knn = Knn.new Classifer.new(train.historic_data, 'SQQQ').trained_examples

# Fetch data: previous 1 days
previous = 1
end_day = 1.days.ago.end_of_day.strftime("%Y%m%d %H:%M:%S")

test = HistoricData.new
test.request 'SQQQ', end_day, previous
test.request %w[ AAPL MSFT GOOG ORCL INTC AMZN QCOM CSCO CMCSA AMGN ], 
  end_day, previous
  
results = Classifer.new(test.historic_data, 'SQQQ').trained_examples

errors = results.inject([]) do |error, result|
  classification = result[:classification]
  example = Hash[ result.find_all {|k,_| k != :classification } ]
  test_classification = knn.classify example
  # error += (classification == test_classification ? 0 : 1)
  error << [classification, test_classification]
end
