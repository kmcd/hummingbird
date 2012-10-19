$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'hummingbird'
require 'test/unit'
require 'active_support/testing/declarative'
require 'redgreen'

class Test::Unit::TestCase
  extend ActiveSupport::Testing::Declarative
end