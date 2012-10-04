$LOAD_PATH << './vendor'
$LOAD_PATH << './lib'

module Hummingbird
end

require 'active_support/all'
require 'date'
require 'java'
require 'ib_gateway'
require 'gateway'
require 'stock'
require 'order'
require 'historic_data'
require 'realtime_data'
require 'classifier'
require 'knn'
