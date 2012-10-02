IBUtils.forEachNDX10 { gateway, i, symbol ->
  def stock = new Stock(symbol)
  gateway.stocks[i] = stock

  // Why is this needed?
  def calendarOpens = Calendar.instance
  calendarOpens.set(['hourOfDay': 9, 'minute': 30, 'second': 0])

  // What is 15?
  gateway.client_socket.reqRealTimeBars(i, stock.contract, 15, 'ASK', 
    Calendar.instance.after(calendarOpens))
}