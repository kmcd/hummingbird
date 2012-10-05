class Example
  attr_reader :current_bar, :previous_bar
  
  def initialize(current_bar, previous_bar)
    @current_bar, @previous_bar = current_bar, previous_bar
  end
  
  def classification
    return unless current_bar && previous_bar
    return if previous_bar.empty?
    return :long if long?
    return :short if short?
  end
  
  def long?
    # TODO: investigate if sensitive to rounding errors, eg 0.0049...
    change(:close) >= 0.05 && change(:low) >= -0.02
  end
  
  def short?
    change(:close) <= -0.05 && change(:high) <= 0.02
  end
  
  def change(ohlc)
    BigDecimal.new(current_bar[ohlc].to_s) - BigDecimal.new(
      previous_bar[ohlc].to_s)
  end
end