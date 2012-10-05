require 'historic_data'
require 'realtime_data'

class MarketData
  include Observable
  extend Forwardable
  def_delegators :historic, :historic_data
  def_delegators :realtime, :realtime_data
  
  # TODO: move to etf_components.yml
  NDX_10 = %w[ AAPL MSFT GOOG ORCL INTC AMZN QCOM CSCO CMCSA AMGN ]
  
  def initialize(tradeable='QQQ', components=NDX_10)
    [tradeable, components].each do |tickers|
      historic.request tickers
      realtime.request tickers
    end
  end
  
  def disconnect
    historic.disconnect
    realtime.disconnect
  end
  
  def historic
    @historic ||= HistoricData.new
  end
  
  def realtime
    @realtime ||= RealtimeData.new
  end
end
