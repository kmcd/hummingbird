require 'gateway'

class HistoricData < Gateway
  def_delegators :client_socket, :reqHistoricalData
  
  def request(symbols, end_date=1.day.ago.end_of_day.strftime("%Y%m%d %H:%M:%S"))
    [symbols].flatten.each do |ticker|
      reqHistoricalData ticker_id(ticker), 
        Stock.new(ticker).contract, end_date, '3 D', '1 min', 
          'ASK', 1, 1
    end
  end

  def historicalData(reqId, date, open, high, low, close, volume, count,
      wap, hasGaps)
    return if date =~ /finished/ # could notify subscriber instead
    time_stamp, ticker = DateTime.parse(date).to_s(:db), tickers.at(reqId)
    
    historic_data[ticker][time_stamp] = {:open => open, :high => high,
      :low => low, :close => close, :volume => volume }
  end
  
  def historic_data
    @historic_data ||= Hash.new {|hash,key| hash[key] = {} }
  end
end
