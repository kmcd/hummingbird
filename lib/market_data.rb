require 'historic_data'
require 'realtime_data'
require 'rufus/scheduler'

class MarketData
  include Observable
  extend Forwardable
  def_delegators :historic, :historic_data
  def_delegators :realtime, :realtime_data
  
  def initialize(tradeable, components)
    # historic.request tradeable
    # historic.request components
    # print "Waiting for historic data "
    # while historic_data.keys.size < components.size + 1
      # print '.' ; sleep 1
    # end
    realtime.request tradeable
    realtime.request components
  end
  
  def realtime_polling(on=true)
    return scheduler.stop unless on
    scheduler.every('5s') { changed ; notify_observers self }
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
  
  def scheduler
    @scheduler ||= Rufus::Scheduler.start_new
  end
end
