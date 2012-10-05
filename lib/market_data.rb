require 'historic_data'
require 'realtime_data'

class MarketData
  include Observable
  attr_reader :tradeable, :components
  NDX_10 = %w[ AAPL MSFT GOOG ORCL INTC AMZN QCOM CSCO CMCSA AMGN ]
  
  def initialize(tradeable='QQQ', components=NDX_10)
    @tradeable, @components = tradeable, components
    # request_historic
    # request_realtime
  end
  
  def request_historic
    historic.request tradeable
    historic.request components
  end
  
  def request_realtime
    realtime.request tradeable
    realtime.request components
  end
  
  def disconnect
    historic.disconnect
    realtime.disconnect
  end
  
  def historic_data
    historic.data
  end
  
  def realtime_data
    realtime.data
  end
  
  def historic
    @historic ||= HistoricData.new
  end
  
  def realtime
    @realtime ||= RealtimeData.new
  end
end
