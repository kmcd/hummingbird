class Knn
  attr_reader :examples
  
  def initialize(examples={})
    @examples = Classifier.new(examples).trained_examples
  end
  
  def classify(data_point, k=7)
    histogram = Hash.new 0
    distances.sort[0..k].each do |distance|
      histogram[ distance.last ] += inverse_weight distance.first
    end
    histogram.sort {|k1, k2| k1.value <=> k2.value }
  end
  
  def distances
    @distances ||= examples.inject({}) do |distances, example|
      distance = euclidean_distance data_point, example
      classification = example['qqq'] # must be pre-computed
      distances << [ distance, classification ]
    end
  end
  
  def euclidean_distance(point_1, point_2)
    sum_sq = 0
    point_1.each do |index,change| 
      sum_sq += ( change - point_2[index] ) ** 2 
    end
    sum_sq ** 0.5
  end
  
  def inverse_weight(distance)
    1.0 / ( distance + 0.1 )
  end
end