class RealtimeData < Gateway
  def initialize
    super
    connect
  end
  
  def fetch_symbols(symbols=[])
    symbols.each {|symbol| request_realtime_data symbol }
  end
  
  def request_realtime_data(symbol)
    client_socket.reqRealTimeBars request_id(symbol), 
      Stock.new(symbol).contract, 5, 'ASK', true
  end
  
  def realtimeBar(reqId, time, open, high, low, close, volume, wap, count)
    puts [requests.at(reqId), reqId, time, open, high, low, close, volume, wap, count].join ' '
  end

  def request_id(symbol)
    requests << symbol unless requests.include? symbol
    requests.index symbol
  end
  
  def requests
    @requests ||= []
  end
  
  def data
    @data ||= Hash.new {|hash,key| hash[key] = {} }
  end
end
