$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'hummingbird'
require 'backtest'

HOLDINGS = { # TODO: move to yaml
   # Falsify GDX using %w[ QQQ TLT VXX UNG ],
  'GDX' => %w[ ABX GG NEM AUY SLW AU GOLD AEM KGC EGO GFI ],
  'QQQ' => %w[ AAPL MSFT GOOG ORCL INTC AMZN QCOM CSCO CMCSA AMGN ],
  'SMH' => %w[ INTC TSM TXN BRCM ARMH ASML AMAT ADI ALTR XLNX ],
  'SDS' => %w[ XLY XLP XLE XLF XLV XLI XLB XLK XLU ],
  'XLB' => %w[ MON DD FCX DOW PX NEM LYB PPG ECL APD ],
  'XLE' => %w[ XOM CVX SLB OXY COP NOV APC APA HAL EOG ],
  'XME' => %w[ CNX CMP BTU ANR ACI WLT ANV CDE X HL CLD ]
}

%w[ QID QLD ].each {|ndx| HOLDINGS[ndx] = HOLDINGS['QQQ'].dup }

# Usage ./bin/backtest.rb QQQ
index = ARGV.first
puts Backtest.new(index, HOLDINGS[index]).report
