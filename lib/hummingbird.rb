$LOAD_PATH << './vendor'
$LOAD_PATH << './lib'

module Hummingbird
end

require 'rubygems'
require 'redis'
require 'active_support/all'  # TODO: only load DateTime parser where needed
require 'java'                # TODO: only load in gateway classes
require 'date'
require 'strategy'
