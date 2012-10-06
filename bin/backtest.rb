$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'hummingbird'
require 'historic_data'

# Fetch data: previous 4 - 2 days
previous = 3
end_day 2.days.ago.end_of_day.strftime("%Y%m%d %H:%M:%S")

train = HistoricData.new
train.request 'QQQ', previous, end_day
train.request %w[ AAPL MSFT GOOG ORCL INTC AMZN QCOM CSCO CMCSA AMGN ], 
  previous, end_day
knn = Knn.new train.historic_data

# Fetch data: previous 1 days
previous = 1
end_day 1.days.ago.end_of_day.strftime("%Y%m%d %H:%M:%S")

test = HistoricData.new
test.request 'QQQ', previous, end_day
test.request %w[ AAPL MSFT GOOG ORCL INTC AMZN QCOM CSCO CMCSA AMGN ], 
  previous, end_day

test.historic_data.each do |bar|
  next if bar['']
  classification = knn.classify bar
end
