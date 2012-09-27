IBUtils.forEachNDX10 { gateway, i, symbol ->
  def stock = new Stock(symbol)
  gateway.stocks[i] = stock

  gateway.client_socket.reqHistoricalData(i, stock.contract, new Date().format("yyyyMMdd HH:mm:ss"), '3 D', '1 min',
          'ASK', 1, 1)
}
