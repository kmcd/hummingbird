class KNearestNeighbours
  attr_reader :examples, :neighbours
  
  def initialize(examples=[], neighbours=7)
    @examples, @neighbours = examples.clone, neighbours
  end
  
  def classify(data_point)
    return if data_point.values.compact.empty?
    return unless classifications = weighted_classifications(data_point)
    # puts "[#{DateTime.now.to_s(:db)}] classification:#{classifications.inspect}"
    classifications.first
  end
  
  def weighted_classifications(data_point)
    weighted_distances(data_point).sort_by {|_,distance| distance }.last
  end
  
  def weighted_distances(data_point)
    default_histogram = Hash.new {|h,neighbours| h[neighbours] = 0 }
    top(data_point).inject( default_histogram ) do |histogram, distance|
      histogram[ distance.last ] += inverse_weight distance.first
      histogram
    end
  end
    
  def top(data_point)
    distances(data_point).sort_by(&:first)[0..neighbours]
  end
  
  def distances(data_point)
    examples.inject([]) do |distances, example|
      training_example = Hash[ example.find_all(&without_classification) ]
      distance = euclidean_distance data_point, training_example
      distances << [ distance, example[:classification] ]
    end.find_all &:first
  end
  
  def euclidean_distance(data_point, example)
    sum_squares = training_examples.map do |ticker|
      next unless data_point[ticker] && example[ticker]
      (data_point[ticker] - example[ticker]) ** 2
    end.compact.reduce(:+)
    sum_squares ** 0.5 if sum_squares
  end
  
  def inverse_weight(distance)
    (1.0 / ( distance + 0.1 )) / 10
  end # TODO: investigate guassian - could be sensitive to noise
  
  def training_examples
    @training_examples ||= examples.
      map {|h| Hash[ h.find_all(&without_classification) ] }.
      map(&:keys).flatten.uniq
  end
  
  def without_classification
    lambda {|neighbours,_| neighbours != :classification }
  end # TODO: move to Example
end