require 'order'

class OrderPlacement
  def update(position)
    puts "[ORDER PLACEMENT] type:#{position.entry} size:#{position.size}"
  end
end
