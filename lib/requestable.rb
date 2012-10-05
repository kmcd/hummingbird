module Requestable
  def ticker_id(symbol)
    tickers << symbol unless tickers.include? symbol
    tickers.index symbol
  end
  
  def tickers
    @tickers ||= []
  end
end
