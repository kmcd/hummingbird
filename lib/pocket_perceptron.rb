require 'perceptron'

class PocketPerceptron < Perceptron
  def train(training_set, iterations=1_000)
    best_error, best_weighting = 1.0/0, nil
    
    iterations.times do
      error_rate = in_sample_error training_set
      
      if error_rate < best_error
        best_error = error_rate
        best_weighting = weights.dup
      end
      break if best_error == 0
      
      training_set.each do |input_vector, desired_output|
        error = desired_output - classify(input_vector, weights)
        next if error == 0
        update_weights input_vector, error
        break
      end
    end
  end
  
  def in_sample_error(training_set)
    training_set.inject(0) do |error_rate, example|
      inputs, result = *example
      error = classify(inputs, weights) == result ? 0 : 1
      error_rate += error
    end
  end
  
  def accuracy(training_set)
    examples = training_set.size.to_f
    (in_sample_error(training_set) / examples) * 100
  end
  
  def augmented_error(lambda=0.5)
  end
end

classifications = train.map(&:last).map do |input_vector, desired_output|
  [ desired_output, p2.classify(input_vector, p2.weights)]
end