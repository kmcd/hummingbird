require 'gateway'
require 'stock'

class RealtimeData < Gateway
  def_delegators :client_socket, :reqRealTimeBars
    
  def request(symbol)
    [symbol].flatten.each do |ticker|
      client_socket.reqRealTimeBars request_id(ticker), 
        Stock.new(ticker).contract, 5, 'ASK', true
    end
  end
  
  def realtimeBar(reqId, time, open, high, low, close, volume, wap, count)
    puts [requests.at(reqId), reqId, time, open, high, low, close, volume,
      wap, count].join ' '
  end
end
