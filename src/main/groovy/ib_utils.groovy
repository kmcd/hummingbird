// FIXME: move balance handling to Account.balance
class IBUtils {
  static def gateway
  static def balance
  static double ticker = 0

  static void forEachNDX10(Closure perform) {
    gateway = new Gateway(client_id: 2)
    gateway.connect()

    def i = 0

    new File("../resources/qqq_holdings.csv").splitEachLine(",") { fields ->
      perform.call(gateway, i++, fields[0])
    }
  }
}
