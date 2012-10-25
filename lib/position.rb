# TODO: move Gateway functionality to Account
class Position < Gateway
  MINIMUM_BALANCE, ACCOUNT_RISK = 25_000, 0.005
  attr_accessor :entry, :account_balance, :profitability
  include Observable
  
  def initialize
    super() # TODO: pass in a/c code from config & environment
    client_socket.reqAccountUpdates true, 'DU125081'
  end
  
  def update(signal)
    self.entry = signal.current
    return unless entry && viable?
    publish
  end
  
  def viable?
    balance_sufficient_for_day_trading? && daily_drawdown_tolerable?
  end
  
  def size
    10_000 # TODO: change to fixed fraction
  end
  
  def daily_drawdown_tolerable?
    account_daily_drawdown_tolerable? && strategy_daily_drawdown_tolerable?
  end
  
  def account_daily_drawdown_tolerable?
    profitability > -(account_balance * ACCOUNT_RISK)
  end
  
  def strategy_daily_drawdown_tolerable?
    true
  end
  
  def balance_sufficient_for_day_trading?
    account_balance > MINIMUM_BALANCE
  end
  
  def updateAccountValue(key, value, currency, accountName)
    case key
      when /(availablefunds)/i  ; self.account_balance  = value.to_f
      when /(realizedpnl)/i     ; self.profitability    = value.to_f
    end
  end # TODO: move to Account (singleton)
end
