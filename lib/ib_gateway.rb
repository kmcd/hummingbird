require 'ib.client.jar'

class IbGateway
  include com.ib.client.EWrapper
  
  def client_socket
    @client_socket ||= com.ib.client.EClientSocket.new self
  end
  
  java_signature 'public accountDownloadEnd(java.lang.String end) {}'
  def accountDownloadEnd(end_at)
  end
  
  java_signature 'public bondContractDetails(int reqId, ContractDetails contractDetails) {}'
  def bondContractDetails(reqId, contractDetails)
  end
  
  java_signature 'public connectionClosed() {}'
  def connectionClosed()
  end
  
  java_signature 'public contractDetails(int reqId, ContractDetails contractDetails) {}'
  def contractDetails(reqId, contractDetails)
  end
  
  java_signature 'public contractDetailsEnd(int reqId) {}'
  def contractDetailsEnd(reqId)
  end
  
  java_signature 'public currentTime(long time) {}'
  def currentTime(time)
  end
  
  java_signature 'public deltaNeutralValidation(int int_1, com.ib.client.UnderComp underComp) {}'
  def deltaNeutralValidation(int_1, underComp)
  end
  
  java_signature 'public deltaNeutralValidation(undercomp) {}'
  def deltaNeutralValidation(undercomp)
  end
  
  java_signature 'public error(Exception e) { println e }'
  def error(e)
  end
  
  java_signature 'public error(String str) { println str }'
  def error(str)
  end
  
  java_signature 'public error(int id, int errorCode, String errorMsg){}'
  def error(id, errorCode, errorMsg)
  end
  
  java_signature 'public execDetails(int orderId, Contract contract, Execution execution) {}'
  def execDetails(orderId, contract, execution)
  end
  
  java_signature 'public execDetailsEnd(int at) {}'
  def execDetailsEnd(at)
  end
  
  java_signature 'public fundamentalData(int reqId, String data) {}'
  def fundamentalData(reqId, data)
  end
  
  java_signature 'public historicalData(int reqId, String date, double open, double high, double low, double close, int volume, int count, double WAP, boolean hasGaps) {}'
  def historicalData(reqId, date, open, high, low, close,volume,count, wap, hasGaps)
  end
  
  java_signature 'public managedAccounts(String accountsList) {}'
  def managedAccounts(accountsList)
  end
  
  java_signature 'public marketDataType(int int_1, int int_2) {}'
  def marketDataType(int_1, int_2)
  end
  
  java_signature 'public nextValidId(int orderId) {}'
  def nextValidId(orderId)
  end
  
  java_signature 'public openOrder(int orderId, Contract contract, Order order, OrderState orderState) {}'
  def openOrder(orderId, contract, order, orderState)
  end
  
  java_signature 'public openOrderEnd() {}'
  def openOrderEnd()
  end
  
  java_signature 'public orderStatus(int orderId, String status, int filled, int remaining, double avgFillPrice, int permId, int parentId, double lastFillPrice, int clientId, String whyHeld) {}'
  def orderStatus(orderId, status, filled, remaining, avgFillPrice, permId, parentId, lastFillPrice, clientId, whyHeld)
  end
  
  java_signature 'public realtimeBar(int reqId, long time, double open, double high, double low, double close, long volume, double wap, int count) {}'
  def realtimeBar(reqId, time, open, high, low, close, volume, wap, count)
  end
  
  java_signature 'public receiveFA(int faDataType, String xml) {}'
  def receiveFA(faDataType, xml)
  end
  
  java_signature 'public scannerData(int reqId, int rank, ContractDetails contractDetails, String distance, String benchmark, String projection, String legsStr) {}'
  def scannerData(reqId, rank, contractDetails, distance, benchmark, projection, legsStr)
  end
  
  java_signature 'public scannerDataEnd(int reqId) {}'
  def scannerDataEnd(reqId)
  end
  
  java_signature 'public scannerParameters(String xml) {}'
  def scannerParameters(xml)
  end
  
  java_signature 'public tickEFP(int tickerId, int tickType, double basisPoints, String formattedBasisPoints, double impliedFuture, int holdDays, String futureExpiry, double dividendImpact, double dividendsToExpiry) {}'
  def tickEFP(tickerId, tickType, basisPoints, formattedBasisPoints, impliedFuture, holdDays, futureExpiry, dividendImpact, dividendsToExpiry)
  end
  
  java_signature 'public tickGeneric(int tickerId, int tickType, double value) {}'
  def tickGeneric(tickerId, tickType, value)
  end
  
  java_signature 'public tickOptionComputation(int tickerId, int field, double impliedVol, double delta, double modelPrice, double pvDividend) {}'
  def tickOptionComputation(tickerId, field, impliedVol, delta, modelPrice, pvDividend)
  end
  
  java_signature 'public tickOptionComputation(int int_1, int int_2, double double1, double double2, double double3, double double4, double double5, double double6, double double7, double double8) {}'
  def tickOptionComputation(int_1,int_2,double_1,double_2,double_3,double_4,double_5,double_6,double_7,double_8)
  end
  
  java_signature 'public tickPrice(int tickerId, int field, double price, int canAutoExecute) {}'
  def tickPrice(tickerId, field, price, canAutoExecute)
  end
  
  java_signature 'public tickSize(int tickerId, int field, int size) {}'
  def tickSize(tickerId, field, size)
  end
  
  java_signature 'public tickSnapshotEnd(int at) {}'
  def tickSnapshotEnd(at)
  end
  
  java_signature 'public tickString(int tickerId, int tickType, String value) {}'
  def tickString(tickerId, tickType, value)
  end
  
  java_signature 'public updateAccountTime(String timeStamp) {}'
  def updateAccountTime(timeStamp)
  end
  
  java_signature 'public updateAccountValue(String key, String value, String currency, String accountName) {}'
  def updateAccountValue(key, value, currency, accountName)
  end
  
  java_signature 'public updateMktDepth(int tickerId, int position, int operation, int side, double price, int size) {}'
  def updateMktDepth(tickerId, position, operation, side, price, size)
  end
  
  java_signature 'public updateMktDepthL2(int tickerId, int position, String marketMaker, int operation, int side, double price, int size) {}'
  def updateMktDepthL2(tickerId, position, marketMaker, operation, side, price, size)
  end
  
  java_signature 'public updateNewsBulletin(int msgId, int msgType, String message, String origExchange) {}'
  def updateNewsBulletin(msgId, msgType, message, origExchange)
  end
  
  java_signature 'public updatePortfolio(Contract contract, int position, double marketPrice, double marketValue, double averageCost, double unrealizedPNL, double realizedPNL, String accountName) {}'
  def updatePortfolio(contract, position, marketPrice, marketValue, averageCost, unrealizedPNL, realizedPNL, accountName)
  end
end