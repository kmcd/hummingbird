class Example
  attr_reader :current_bar, :previous_bar, :entry, :exit
  
  def initialize(current_bar, previous_bar, entry=0.05, exit=0.02)
    @current_bar, @previous_bar = current_bar, previous_bar
    @entry, @exit = entry, exit
  end
  
  def classification
    return unless current_bar && previous_bar
    return if previous_bar.empty?
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
    (BigDecimal.new(current_bar[ohlc].to_s) - BigDecimal.new(
      previous_bar[ohlc].to_s) ).to_f
  end
end