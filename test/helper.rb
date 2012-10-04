require 'test/unit'
require 'rubygems'
require 'active_support/testing/declarative'
require 'redgreen'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'hummingbird'

class Test::Unit::TestCase
  extend ActiveSupport::Testing::Declarative
end