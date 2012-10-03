class HistoricalData < Gateway
  def_delegators :client_socket, :reqHistoricalData
    
  def request_historical_data(symbol, end_date=Time.now.
    strftime("%Y%m%d %H:%M:%S"))
  
    [symbol].flatten.each do |ticker|
      reqHistoricalData request_id(ticker), 
        Stock.new(ticker).contract, end_date, '3 D', '1 min', 
          'ASK', 1, 1
    end
  end

  def historicalData(reqId, date, open, high, low, close, volume, count,
      wap, hasGaps)
    return if date =~ /finished/
    
    data[requests.at(reqId)][date] = {:open => open, :high => high,
      :low => low, :close => close, :volume => volume }
  end
end
