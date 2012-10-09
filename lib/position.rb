class Position < Gateway
  attr_accessor :entry, :account_balance, :profitability
  include Observable
  
  def initialize
    super()
    client_socket.reqAccountUpdates true, 'DU125081'
  end
  
  def update(signal)
    entry = signal.current
    return unless entry && viable?
    changed
    notify_observers self
  end
  
  def viable?
    balance > 25000 && profitability > -200
  end
  
  def size
    10_000 # fixed for evaluation
  end
  
  def updateAccountValue(key, value, currency, accountName)
    puts [key, value, currency, accountName].join ' '
    case key
      when /(AvailableFunds)/i  ; self.account_balance  = value.to_f
      when /(RealizedPNL)/i     ; self.profitability    = value.to_f
    end
  end
end
