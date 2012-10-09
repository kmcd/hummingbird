class Position < Gateway
  attr_accessor :entry, :account_balance, :profitability
  include Observable
  
  def initialize
    super()
    client_socket.reqAccountUpdates true, 'DU125081'
  end
  
  def update(signal)
    self.entry = signal.current
    return unless entry && viable?
    log
    changed
    notify_observers self
  end
  
  def viable?
    account_balance > 25000 && profitability > -200
  end
  
  def size
    10_000 # fixed for evaluation
  end
  
  def updateAccountValue(key, value, currency, accountName)
    case key
      when /(AvailableFunds)/i  ; self.account_balance  = value.to_f
      when /(RealizedPNL)/i     ; self.profitability    = value.to_f
    end
  end
  
  def log
    logger.info "[POSITION] entry:#{entry} a/c:#{account_balance}, p+l: #{profitability}"
  end
  
  def logger
    @logger || Logger.new("./log/position_#{Date.today.to_s(:db)}.log")
  end
end
