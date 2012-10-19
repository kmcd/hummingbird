$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'hummingbird'
require 'backtest'

HOLDINGS = { 
  'QQQ' => %w[ AAPL MSFT GOOG ORCL INTC AMZN QCOM CSCO CMCSA AMGN ],
  'GDX' => %w[ ABX GG NEM AUY SLW AU GOLD AEM KGC EGO GFI ],
  'XLE' => %w[ XOM CVX SLB OXY COP NOV APC APA HAL EOG ],
  'XLB' => %w[ MON DD FCX DOW PX NEM LYB PPG ECL APD ],
  'SMH' => %w[ INTC TSM TXN BRCM ARMH ASML AMAT ADI ALTR XLNX ]
}

%w[ QID QLD ].each {|ndx| HOLDINGS[ndx] = HOLDINGS['QQQ'].dup }

# Usage ./bin/backtest.rb QQQ
index = ARGV.first
puts Backtest.new(index, HOLDINGS[index]).report
