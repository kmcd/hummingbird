IBUtils.forEachNDX10 { gateway, i, symbol ->
  def stock = new Stock(symbol)
  gateway.stocks[i] = stock

  gateway.client_socket.reqRealTimeBars(i, stock.contract, 15, 'ASK', true)
}