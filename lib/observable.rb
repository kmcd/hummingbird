require 'observer'

module Observable
  def publish
    changed
    notify_observers self
  end
end
