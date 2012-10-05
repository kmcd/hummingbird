require 'historic_data'
require 'realtime_data'
require 'rufus/scheduler'

class MarketData
  include Observable
  extend Forwardable
  def_delegators :historic, :historic_data
  def_delegators :realtime, :realtime_data
  
  # TODO: move to etf_components.yml
  NDX_10 = %w[ AAPL MSFT GOOG ORCL INTC AMZN QCOM CSCO CMCSA AMGN ]
  
  def initialize(tradeable='QQQ', components=NDX_10)
    historic.request tradeable
    historic.request components
    realtime.request components
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
  
  def realtime_polling
    scheduler.every '5s' do # May be using quotes that are 5s old!
      changed
      notify_observers self
    end
  end
  
  def scheduler
    @scheduler ||= Rufus::Scheduler.start_new
  end
end

# s.market_data.scheduler.stop
