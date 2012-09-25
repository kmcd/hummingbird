gateway = new Gateway(client_id: 2)
gateway.connect()

def i = 0

new File("../resources/qqq_holdings.csv").splitEachLine(",") { fields ->
  def stock = new Stock(fields[0])
  gateway.stocks[i] = stock

  gateway.client_socket.reqHistoricalData(i, stock.contract, new Date().format("yyyyMMdd HH:mm:ss"), '3 D', '1 min',
          'ASK', 1, 1)

}