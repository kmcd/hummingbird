$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'hummingbird'
require 'backtest'

HOLDINGS = {
  'GDX' => %w[ ABX AEM AU AUY EGO GG GOLD KGC NEM SLW ],
  'QLD' => %w[ AAPL MSFT GOOG ORCL INTC AMZN QCOM CSCO CMCSA AMGN ],
  'SDS' => %w[ XLY XLP XLE XLF XLV XLI XLB XLK XLU ],
  'XLE' => %w[ XOM CVX SLB OXY COP NOV APC APA HAL EOG ],
  'XME' => %w[ CNX CMP BTU ANR ACI WLT ANV CDE X HL CLD ],
  'VXX' => %w[ SPY XIV ],
  'SPY' => %w[ IVV ]
}

# Usage ./bin/backtest.rb QQQ
index = ARGV.first
puts Backtest.new(index, HOLDINGS[index]).report
