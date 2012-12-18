require 'gateway'
require 'requestable'

class HistoricData < Gateway
  include Requestable
  def_delegators :client_socket, :reqHistoricalData
  
  def self.request(days, previous, tickers, wait=10, timeframe=nil)
    hd = new
    hd.request tickers, days, previous, wait, timeframe
    hd.disconnect
    hd.historic_data
  end
  
  def request(symbols, end_date=1, days=3, wait=0, timeframe='1 min',
    price='ASK')
  
    formatted_end = (end_date.is_a?(Numeric) ? end_date.day.ago.
      end_of_day : end_date).strftime "%Y%m%d %H:%M:%S"
    
    lookback = days.is_a?(Numeric) ? "#{days.to_s} D" : days
    
    [symbols].flatten.each do |ticker|
      reqHistoricalData ticker_id(ticker), Stock.new(ticker).contract, 
        formatted_end, lookback, timeframe, price, 1, 1
      sleep wait
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
