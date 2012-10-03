module Requestable
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
