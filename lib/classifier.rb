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
