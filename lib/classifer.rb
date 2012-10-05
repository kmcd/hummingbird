require 'bigdecimal'
require 'example'

class Classifer
  attr_reader :training_examples, :examples
  
  def initialize(examples={}, index='QQQ')
    @examples, @training_examples = examples, examples[index].clone
  end
  
  def trained_examples
    @trained_examples ||= train_examples
  end
  
  def train_examples
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
    HistoricData::NDX_10.inject({}) do |features,ticker|
      features[ticker] = percent_change_close(ticker, example)
      features
    end
  end
  
  def percent_change_close(ticker, example)
    current_time_stamp = example.first
    previous_time_stamp = (DateTime.parse(current_time_stamp) - 1.minute).
      to_s :db
    return unless examples[ticker] && examples[ticker][previous_time_stamp]
    
    current_close = examples[ticker][current_time_stamp][:close]
    previous_close = examples[ticker][previous_time_stamp][:close]
    (current_close / previous_close) - 1
  end
end
