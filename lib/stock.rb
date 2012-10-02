import com.ib.client.Contract
import com.ib.client.ContractDetails

class Stock
  attr_reader :contract
  
  def initialize(symbol)
    @contract = Contract.new
    contract.m_symbol = symbol
    contract.m_secType = "STK"
    contract.m_exchange = "SMART"
    contract.m_primaryExch  = "ARCA"
    contract.m_currency = "USD"
  end
  
  def symbol
    contract.m_symbol
  end
end
