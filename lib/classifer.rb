require 'bigdecimal'
require 'example'

class Classifer
  attr_reader :training_examples, :examples
  
  def initialize(examples={}, index='QQQ')
    @training_examples = examples[index].clone
    @examples = Hash[ examples.find_all {|ticker,_| ticker != index } ]
  end
  
  def trained_examples
    @trained_examples ||= train_examples
  end
  
  def train_examples # OPTIMIZE: takes 10 seconds
    training_examples.inject([]) do |trained_examples, example|
      trained_examples << {:classification => classify(example) }.
        merge!(features(example))
    end
  end
  
  def classify(example)
    current_bar = example.last
    time_stamp = (DateTime.parse(example.first) - 1.minute).to_s :db
    previous_bar = training_examples[time_stamp]
    Example.new(current_bar, previous_bar).classification
  end
  
  def features(example)
    examples.keys.inject({}) do |features,ticker|
      features[ticker] = percent_change_close(ticker, example)
      features
    end
  end
  
  def percent_change_close(ticker, example)
    current_time_stamp = example.first
    previous_time_stamp = (DateTime.parse(current_time_stamp) - 1.minute).
      to_s :db
    return unless examples[ticker] && examples[ticker][previous_time_stamp]
    
    current   = examples[ticker][current_time_stamp][:close].to_s
    previous  = examples[ticker][previous_time_stamp][:close].to_s
    change    = ( BigDecimal.new(current) / BigDecimal.new(previous) ) - 1
    change.nan? ? 0.0 : change.to_f
  end
end
