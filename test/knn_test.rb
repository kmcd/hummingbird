require 'helper'

# load 3d worth of data: 
# Classifer.new YAML.load(File.read("./test/qqq_ndx10.yml")
class KnnTest < Test::Unit::TestCase
  def assert_classified(classification, data_point, examples)
    knn = Knn.new examples
    assert_equal classification, knn.classify(data_point)
  end
  
  test "long classification" do
    assert_classified :long, {'AAPL' => 0.01},
      [{:classification => :long, 'AAPL' => 0.01 }]
  end
  
  test "not long classification" do
    assert_classified nil, {'AAPL' => 0.01},
      [{:classification => nil, 'AAPL' => 0.01 },
      {:classification => :long, 'AAPL' => 0.02 }]
  end
  
  test "short classification" do
    assert_classified :short, {'AAPL' => 0.01},
      [{:classification => :short, 'AAPL' => 0.01 },
       {:classification => :long, 'AAPL' => 0.011 }]
  end
  
  test "euclidean distance" do
    knn = Knn.new [{:classification => nil, 'AAPL' => 0.01 }]
    assert_equal 0.0, knn.euclidean_distance({'AAPL' => 1 }, {'AAPL' => 1 })
    assert_equal 1.0, knn.euclidean_distance({'AAPL' => 1 }, {'AAPL' => 2 })
  end
  
  test "inverse weight" do
    knn = Knn.new [{:classification => nil, 'AAPL' =>1 },
      {:classification => :long, 'AAPL' => 2 }]
    weighted_distances = knn.weighted_distances({'AAPL' => 0.01}, 7)
    
    assert_in_delta weighted_distances[nil], 0.0917, 0.01
    assert_in_delta weighted_distances[:long], 0.047, 0.01
  end
  
  test "handle first bar" do
    assert_classified :long, {'AAPL' => 0.01},
      [{:classification => nil, 'AAPL' => nil },
      {:classification => :long, 'AAPL' => 0.01 }]
  end
end