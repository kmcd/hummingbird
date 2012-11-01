require 'csv'
require 'yaml'
require 'bigdecimal'

def features(*args)
  open, high, low, close = *args.map {|price| BigDecimal.new price }
  
  [ (high / open)   - 1,
    (low / open)    - 1,
    (close / open)  - 1  ].map &:to_f
end

def yaml_dump(data, filename)
  File.open(filename, 'w') {|file| YAML.dump(data, file) }
end

dataset = Hash.new {|h,k| h[k] = [ [], 0 ] }

CSV.foreach("data/gdx_06_04-07_2012.csv") do |ticker, timestamp, open, high, low, close, _|
  next if ticker == "Ticker"
  
  if ticker == 'GDX'
    long = ( [close, open].map {|p| BigDecimal.new p }.reduce('-').
      to_f >= 0.05 ) ? 1 : 0
    previous_minute = (DateTime.parse(timestamp) - 1.minute).to_s :db
    dataset[previous_minute][-1] = long unless previous_minute.match /09:29:59/
  else
    time = DateTime.parse(timestamp).to_s :db
    (dataset[time][0] << features(open, high, low, close)).flatten!
  end
end

validation_size = (dataset.keys.size * 0.2).round
out_of_sample_size = (dataset.keys.size * 0.1).round

dataset = dataset.to_a
validation = dataset.shuffle.shift validation_size
test = dataset.shuffle.shift out_of_sample_size
train = dataset.dup

yaml_dump train, 'data/gdx_06_04-07_2012.train.yml'
yaml_dump test, 'data/gdx_06_04-07_2012.test.yml'
yaml_dump validation, 'data/gdx_06_04-07_2012.validation.yml'
