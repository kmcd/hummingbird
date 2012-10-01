import com.ib.client.Contract

class Stock {
  def contract = new Contract()

  Stock(symbol) {
    contract.m_symbol = symbol
    contract.m_secType = "STK"
    contract.m_exchange = "SMART"
    contract.m_primaryExch = "ARCA" // Should this not be SMART or NASDAQ?
    contract.m_currency = "USD"
  }

  def bid() { Quote.current_bid(symbol()) }

  def ask() { Quote.current_ask(symbol()) }

  def symbol() { contract.m_symbol }
}
