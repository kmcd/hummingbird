require 'gateway'
require 'stock'

class RealtimeData < Gateway
  def_delegators :client_socket, :reqRealTimeBars
    
  def request(symbol)
    [symbol].flatten.each do |ticker|
      reqRealTimeBars ticker_id(ticker), Stock.new(ticker).contract, 5, 
        'ASK', false
    end
  end
  
  def realtimeBar(reqId, time, open, high, low, close, volume, wap, count)
    # TODO: dry up with HistoricData#historicalData
    time_stamp = Time.at(time).to_s :db
    
    data[tickers.at(reqId)][time_stamp] = {:open => open, :high => high,
      :low => low, :close => close, :volume => volume }
  end
  
  def data
    # Should be notifying Q(12) for current minute with 5 second data
    # Workaround: poll every 5 seconds & take latest
    @data ||= Hash.new {|hash,key| hash[key] = {} }
  end
end
