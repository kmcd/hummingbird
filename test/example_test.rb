require 'helper'

class ExampleTest < Test::Unit::TestCase
  def example(args={})
    close = args[:close]  || 0
    low   = args[:low]    || 0
    high  = args[:high]   || 0
    
    Example.new(
      {:close => 60.0+close, :low => 60.0+low, :high => 60.0+high},
      {:close => 60.0, :low => 60.0, :high => 60.0} )
  end
  
  def assert_classified(classification, args)
    assert_equal classification, example(args).classification
  end
  
  test "not long" do
    assert_classified nil,    :close => 0.04
    assert_classified nil,    :close => 0.05, :low => -0.03
    assert_classified nil,    :close => 0.06, :low => -0.03
  end
  
  test "long" do
    assert_classified :long,  :close => 0.05
    assert_classified :long,  :close => 0.05, :low => -0.01
    assert_classified :long,  :close => 0.05, :low => -0.02
    assert_classified :long,  :close => 0.06
    assert_classified :long,  :close => 0.06, :low => -0.02
  end
  
  test "not short" do
    assert_classified nil, :close => -0.04
    assert_classified nil, :close => -0.05, :high => 0.03
    assert_classified nil, :close => -0.06, :high => 0.03
  end
  
  test "short" do
    assert_classified :short, :close => -0.05
    assert_classified :short, :close => -0.05, :high => 0.01
    assert_classified :short, :close => -0.05, :high => 0.02
    assert_classified :short, :close => -0.06
    assert_classified :short, :close => -0.06, :high => 0.02
  end
end
