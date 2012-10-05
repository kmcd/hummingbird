class Position # Sizer
  include Observable
  
  def update(signal)
    puts "[POSITION] #{signal}"
  end
end
