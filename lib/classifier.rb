require 'bigdecimal'

class Classifier
  attr_reader :training_examples, :examples
  
  def initialize(examples={}, index='QQQ')
    @examples, @training_examples = examples, examples[index].clone
  end
  
  def trained_examples
    @trained_examples ||= train_examples
  end
  
  def train_examples
    training_examples.each {|example| classify example }
    examples.merge! training_examples
  end
  
  def classify(example)
    current_bar = example.last
    previous_bar = training_examples[example.first - 1.minute]
    
    training_examples[example.first].merge! :classification => 
      Example.new(current_bar, previous_bar).classification
  end
end
