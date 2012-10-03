$LOAD_PATH << './vendor'
$LOAD_PATH << './lib'

module Hummingbird
end

require 'java'
require 'ib_gateway'
require 'gateway'
require 'stock'
require 'order'
require 'realtime_data'
