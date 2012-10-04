require 'bigdecimal'

class Classifier
  attr_reader :training_examples
  
  def initialize(training_examples={})
    @training_examples = training_examples.clone
  end
  
  def inspect
    nil
  end
  
  def trained_examples
    @trained_examples ||= train_examples
  end
  
  def train_examples
    training_examples['QQQ'].each {|example| classify example }
    training_examples
  end
  
  def classify(example)
    current_bar = example.last
    previous_bar = training_examples[example.first - 1.minute]
    
    training_examples['QQQ'][example.first].merge! :classification => 
      Example.new(current_bar, previous_bar).classification
  end
end

class Example
  attr_reader :current_bar, :previous_bar
  
  def initialize(current_bar, previous_bar)
    @current_bar, @previous_bar = current_bar, previous_bar
  end
  
  def classification
    return if previous_bar.empty?
    return :long if long?
    return :short if short?
  end
  
  def long?
    change(:close) >= 0.05 && change(:low) >= -0.02
  end
  
  def short?
    change(:close) <= -0.05 && change(:high) <= 0.02
  end
  
  def change(ohlc)
    BigDecimal.new(current_bar[ohlc].to_s) - BigDecimal.new(previous_bar[ohlc].to_s)
  end
end
