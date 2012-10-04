require 'helper'

class ClassifierTest < Test::Unit::TestCase
  def setup
    @previous_bar = DateTime.parse '2012-01-01 09:30'
    @current_bar = DateTime.parse '2012-01-01 09:31'
  end
  
  def training_examples(close=0)
    { 'QQQ' => { 
      @previous_bar => {:close => 60.0, :low => 60.0, :high => 60.0},
      @current_bar  => {:close => 60.0+close, :low => 60.0, :high => 60.0 }
    }}
  end
  
  def trained_examples(close_change)
    Classifier.new(training_examples(close_change)).trained_examples['QQQ']
  end
  
  def assert_classified(classification, bar, close_change=0)
    assert_equal classification, trained_examples(close_change)[bar][:classification]
  end
  
  test "not long" do
    assert_classified nil, @previous_bar
    assert_classified nil, @current_bar
    assert_classified nil, @current_bar, 0.04
  end
  
  test "long" do
    assert_classified :long, @current_bar, 0.05
  end
  
  test "not short" do
    assert_classified nil, @current_bar, -0.04
  end
  
  test "short" do
    assert_classified :short, @current_bar, -0.05
  end
end