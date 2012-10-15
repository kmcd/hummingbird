require 'rake'
require 'rake/testtask'

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*test.rb'
  test.verbose = true
end

task :default => :test

desc 'Run Interactive Brokers Trader Work Station'
task(:tws) { `./bin/tws.sh` }

desc 'Run Interactive Brokers API stand-alone gateway'
task(:gateway) { `./bin/gateway.sh` }

desc 'Backtest last trading day' # TODO: accept date range args
task(:backtest) { `ruby ./bin/backtest.rb` }

desc 'irb console with classes pre-loaded'
task(:console)  { `irb -r lib/hummingbird.rb` }