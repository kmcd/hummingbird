require 'historic_data'
require 'realtime_data'
require 'rufus/scheduler'

class MarketData
  include Observable
  extend Forwardable
  def_delegators :historic, :historic_data
  def_delegators :realtime, :realtime_data
  attr_reader :tradeable, :components
  attr_accessor :polling
  
  def initialize(tradeable, components)
    @tradeable, @components = tradeable, components
    historic.request tradeable
    historic.request components
    realtime.request tradeable
    realtime.request components
  end
  
  def realtime_polling(on=true)
    return scheduler.stop unless on
    return unless all_data_available?
    self.polling = scheduler.cron('* 14-21 * * 1-5') { publish }
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
  
  def all_data_available?
    ready?(historic_data) && ready?(realtime_data)
  end
  
  def ready?(data)
    data.keys.size == [tradeable, components].flatten.size
  end
end
