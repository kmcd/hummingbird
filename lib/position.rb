# TODO: move Gateway functionality to Account
class Position < Gateway
  attr_accessor :entry, :account_balance, :profitability
  include Observable
  
  def initialize
    super() # FIXME: pass in a/c code from config & environment
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
    balance_sufficient_for_day_trading? && daily_drawdown_tolerable?
  end
  
  def size
    5_000 # fixed for evaluation
  end
  
  def daily_drawdown_tolerable?
    profitability > -125
  end
  
  def balance_sufficient_for_day_trading?
    account_balance > 25000
  end
  
  # TODO: move to account
  def updateAccountValue(key, value, currency, accountName)
    case key
      when /(availablefunds)/i  ; self.account_balance  = value.to_f
      when /(realizedpnl)/i     ; self.profitability    = value.to_f
    end
  end
  
  def log
    logger.info "[POSITION] entry:#{entry} a/c:#{account_balance}, p+l: #{profitability}"
  end
  
  def logger
    @logger || Logger.new("./log/position_#{Date.today.to_s(:db)}.log")
  end
end
