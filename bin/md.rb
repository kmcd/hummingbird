$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'hummingbird'
load 'lib/market_data.rb'
load 'lib/realtime_data.rb'

md = MarketData.new
md.realtime_polling
