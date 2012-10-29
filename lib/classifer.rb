require 'bigdecimal'
require 'example'

class Classifer
  attr_reader :training_examples, :examples
  
  def initialize(ticker, examples={})
    @training_examples = examples[ticker].clone
    @examples = Hash[ examples.find_all {|example,_| example != ticker } ]
  end
  
  def trained_examples
    @trained_examples ||= training_examples.each_cons(2).
      inject([]) {|training, examples| training << trained(examples) }
  end
  
  def trained(examples)
    current_bar, next_bar = *examples
    time_stamp, ohlc = current_bar.first, next_bar.last
    classification = Example.new(ohlc).classification
    features(time_stamp).merge!( { :classification => classification } )
  end
  
  def features(time_stamp)
    examples.keys.inject({}) do |features,ticker|
      features[ticker] = percent_change(:close,  ticker, time_stamp)
      features
    end
  end
  
  def percent_change(ohlc, ticker, time_stamp)
    ohlc_price  = price ticker, time_stamp, ohlc
    open        = price ticker, time_stamp, :open
    change      = ( ohlc_price / open  ) - 1
    change.nan? ? 0.0 : change.to_f
  end
  
  def price(ticker, time_stamp, ohlc)
    BigDecimal.new examples[ticker][time_stamp][ohlc].to_s
  end
end
