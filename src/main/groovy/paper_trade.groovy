import Gateway

gateway = new Gateway(client_id: 2)
gateway.connect()

try {
  def i = 0
  new File("D:/work/IB/hummingbird/src/main/resources/qqq_holdings.csv").splitEachLine(",") {fields ->
    println "${i++} - ${fields[0]}"

    def stock = new Stock(fields[0])
    gateway.stocks[i] = stock

    gateway.client_socket.reqHistoricalData(i, stock.contract, '20120818 15:16:55 GMT', '3 D', '1 min', 'ASK', 1, 1)
  }
} catch (Exception e) {
  e.printStackTrace()
}

//position = new Position()
//pair = new Pair()
//
//while (true) {
//  if (position.available && pair.entry_signal()) {
//    position = new Position(pair)
//    pair_order = new PairOrder(gateway)
//    pair_order.enter(position)
//  }
//
//  if (position.profitable()) { pair_order.exit() }
//}
