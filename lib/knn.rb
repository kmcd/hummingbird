class Knn
  attr_reader :examples
  
  def initialize(examples=[])
    @examples = examples.clone
  end
  
  def classify(data_point, k=7)
    weighted_distances(data_point, k).sort_by {|_,distance| distance }.last.first
  end
  
  def weighted_distances(data_point, k)
    top(data_point, k).inject( Hash.new {|h,k| h[k] = 0 } ) do |histogram, distance|
      histogram[ distance.last ] += inverse_weight distance.first
      histogram
    end
  end
    
  def top(data_point, k)
    distances(data_point).sort_by(&:first)[0..k]
  end
  
  def distances(data_point)
    examples.inject([]) do |distances, example|
      distance = euclidean_distance data_point, example
      distances << [ distance, example[:classification] ]
    end.find_all &:first
  end
  
  def euclidean_distance(data_point, example)
    sum_squares = HistoricData::NDX_10.map do |ticker|
      next unless data_point[ticker] && example[ticker]
      (data_point[ticker] - example[ticker]) ** 2
    end.compact.reduce(:+)
    sum_squares ** 0.5 if sum_squares
  end
  
  # TODO: investigate guassian - could be sensitive to noise
  def inverse_weight(distance)
    (1.0 / ( distance + 0.1 )) / 10
  end
end