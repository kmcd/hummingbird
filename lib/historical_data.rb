class HistoricalData < Gateway
  def initialize
    super
    connect
  end
  
  def fetch_symbols(symbols=[])
    symbols.each {|symbol| request_historical_data symbol }
  end
  
  def request_historical_data(symbol)
    end_date = Time.now.strftime "%Y%m%d %H:%M:%S"
    client_socket.reqHistoricalData request_id(symbol), 
      Stock.new(symbol).contract, end_date, '3 D', '1 min', 
        'ASK', 1, 1
  end

  def historicalData(reqId, date, open, high, low, close, volume, count,
      wap, hasGaps)
    return if date =~ /finished/
    
    data[requests.at(reqId)][date] = {:open => open, :high => high,
      :low => low, :close => close, :volume => volume }
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
