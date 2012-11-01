require 'helper'
require 'pocket_perceptron'

class PocketPerceptronTest < Test::Unit::TestCase
  def nand_training_set 
    [ 
      [[1, 0, 0], 1], 
      [[1, 0, 1], 1], 
      [[1, 1, 0], 1], 
      [[1, 1, 1], 0] 
    ]
  end
  
  test "nand training set (pocket)" do
    perceptron = PocketPerceptron.new 3
    perceptron.train nand_training_set
    
    [0.8, -0.2, -0.1].zip(perceptron.weights).each do |weight, perceptron|
      assert_in_delta weight, perceptron, 0.001
    end
  end
end