require 'gateway'

class HistoricData < Gateway
  NDX_10 = %w[ AAPL MSFT GOOG ORCL INTC AMZN QCOM CSCO CMCSA AMGN ]
  def_delegators :client_socket, :reqHistoricalData
  
  def ndx10
    request ['QQQ'] + NDX_10
  end
  
  def request(symbols, end_date=Time.now.strftime("%Y%m%d %H:%M:%S"))
    [symbols].flatten.each do |ticker|
      reqHistoricalData request_id(ticker), 
        Stock.new(ticker).contract, end_date, '3 D', '1 min', 
          'ASK', 1, 1
    end
  end

  def historicalData(reqId, date, open, high, low, close, volume, count,
      wap, hasGaps)
    return if date =~ /finished/
    time_stamp, ticker = DateTime.parse(date).to_s(:db), requests.at(reqId)
    
    data[ticker][time_stamp] = {:open => open, :high => high,
      :low => low, :close => close, :volume => volume }
  end
  
  def data
    @data ||= Hash.new {|hash,key| hash[key] = {} }
  end
end
