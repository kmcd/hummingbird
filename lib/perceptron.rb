class Perceptron
  attr_reader :weights, :threshold, :learning_rate
  
  def initialize(dimensions, threshold=0.5, learning_rate=0.1)
    @weights = Array.new dimensions, 0
    @threshold, @learning_rate = threshold, learning_rate
  end
  
  def train(training_set)
    while true
      error_count = 0
      
      training_set.each do |input_vector, desired_output|
        error = desired_output - result(input_vector, weights)
        next if error == 0
        error_count += 1
        update_weights input_vector, error
      end
      
      break if error_count == 0
    end
    weights
  end
  
  def update_weights(input_vector, error)
    input_vector.each_with_index do |value, index|
      weights[index] += learning_rate * error * value
    end
  end
  
  def result(input_vector, weights)
    sum(input_vector, weights) > threshold ? 1 : 0
  end
  
  def sum(values,weights)
    values.zip(weights).map {|value, weight| value * weight }.reduce '+'
  end
end
