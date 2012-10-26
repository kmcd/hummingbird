class Example
  attr_reader :current_bar, :entry, :exit
  
  def initialize(current_bar, entry=0.05, exit=0.02)
    @current_bar = current_bar
    @entry, @exit = entry, exit
  end
  
  def classification
    return :long if long?
    :short if short?
  end
  
  def long?
    change(:close) >= entry && change(:low) >= -exit
  end # TODO: investigate if sensitive to rounding errors, eg 0.0049...
  
  def short?
    change(:close) <= -entry && change(:high) <= exit
  end
  
  def change(ohlc)
    (price(ohlc) - price(:open)).to_f
  end
  
  def price(ohlc)
    BigDecimal.new current_bar[ohlc].to_s
  end
end