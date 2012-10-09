require 'gateway'
require 'requestable'
require 'stock'
require 'deck'

class RealtimeData < Gateway
  include Requestable
  def_delegators :client_socket, :reqRealTimeBars
    
  def request(symbol)
    [symbol].flatten.each do |ticker|
      reqRealTimeBars ticker_id(ticker), Stock.new(ticker).contract, 5, 
        'ASK', false
    end
  end
  
  def realtimeBar(reqId, time, open, high, low, close, volume, wap, count)
    time_stamp = Time.at(time).to_s :db
    logger.info "[5s bar] #{time_stamp} #{tickers.at(reqId)}"
    
    realtime_data[tickers.at(reqId)].add({:open => open, :high => high,
      :low => low, :close => close, :volume => volume, 
      :time_stamp => time_stamp })
  end
  
  def current_ask(ticker)
    realtime_data[ticker].current_close
  end
  
  def realtime_data
    @realtime_data ||= Hash.new {|h,k| h[k] = Deck.new(11) }
  end
  
  def logger
    @logger || Logger.new("./log/realtime_data_#{Date.today.to_s(:db)}.log")
  end # TODO: move to Loggable
end
