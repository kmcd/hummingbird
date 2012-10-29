require 'backtest'

class Replay < Backtest
  def classifications
    minutes.each_cons(2) do |current_minute,next_minute|
      actual = Example.new(test[index][next_minute]).classification.to_s
      classification = classify current_minute
      
      print next_minute.ljust 20
      print classification.ljust 5
      print ohlc_change(next_minute).join.ljust 20
      print actual
      puts
    end
  end
  
  def ohlc_change(next_minute)
    ohlc = test[index][next_minute]
    open_close_change = ohlc[:close] - ohlc[:open]
    open_high_change = ohlc[:high] - ohlc[:open]
    open_low_change = ohlc[:low] - ohlc[:open]
    
    [ "%.2f" % open_close_change,
      "%.2f" % open_high_change,
      "%.2f" % open_low_change ].map {|change| change.rjust 6 }
  end
  
  def classify(time_stamp)
    current_bars = [index,components].flatten.inject({}) do |bars,ticker|
      bars[ticker] = { time_stamp => test[ticker][time_stamp] }
      bars
    end
    example = Classifer.new(index, current_bars).trained_examples.first
    knn.classify(example).to_s
  end
  
  def minutes
    test[index].keys.sort
  end
end