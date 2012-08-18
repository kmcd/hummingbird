require 'java'

java_import com.ib.client.Contract
java_import com.ib.client.ContractDetails
java_import com.ib.client.EClientSocket
java_import com.ib.client.EWrapper
java_import com.ib.client.EWrapperMsgGenerator
java_import com.ib.client.Execution
java_import com.ib.client.Order
java_import com.ib.client.OrderState
java_import com.ib.client.UnderComp
  
class IBGateway 
  include EWrapper
  @@client_socket = EClientSocket.new self
  
  java_signature "void accountDownloadEnd(String)"
  def accountDownloadEnd(account)
  end

  java_signature "void bondContractDetails(int,ContractDetails)"
  def bondContractDetails(reqId,contractDetails) 
  end

  java_signature "void connectionClosed()"
  def connectionClosed() 
  end

  java_signature "void contractDetails(int,ContractDetails)"
  def contractDetails(reqId,contractDetails) 
  end

  java_signature "void contractDetailsEnd(int)"
  def contractDetailsEnd(contract) 
  end

  java_signature "void currentTime(long)"
  def currentTime(time) 
  end

  java_signature "void error(Exception)"
  def error(e)
    puts e
  end
  
  java_signature "void error(str)"
  def error(str)
    puts str
  end
    
  java_signature "void error(int,int,errorMsg)"
  def error(id,errorCode,errorMsg)
  end

  java_signature "void execDetails(int,Contract,Execution)"
  def execDetails(orderId,contract,execution) 
  end

  java_signature "void execDetailsEnd(int)"
  def execDetailsEnd(at) 
  end

  java_signature "void historicalData(int,String,double,double,double,double,int,int,double,boolean)"
  def historicalData(reqId,date, open, high, low, close, volume, count, wap,hasGaps) 
  end

  java_signature "void marketDataType(int,int)"
  def marketDataType(int_1,int_2) 
  end

  java_signature "void nextValidId(orderId)"
  def nextValidId(orderId) 
  end

  java_signature "void openOrder(orderId,Contract contract,Order order,OrderState orderState)"
  def openOrder(orderId,contract,order,orderState) 
  end

  java_signature "void openOrderEnd()"
  def openOrderEnd() 
  end

  java_signature "void orderStatus(int,String,int,int,double,int,int,double,int,String)"
  def orderStatus(orderId, status, filled, remaining, avgFillPrice, permId, parentId, lastFillPrice, clientId, whyHeld) 
  end

  java_signature "void realtimeBar(int,long,double,double,double,double,long,double,int)"
  def realtimeBar(reqId, time, open, high, low, close, lon , wap, count)
  end

  java_signature "void tickGeneric(int,int,double)"
  def tickGeneric(tickerId, tickType, value) 
  end

  java_signature "void tickPrice(int,int,double,int)"
  def tickPrice( tickerId, field, price, canAutoExecute)  
  end

  java_signature "void tickSize(int,int,int)"
  def tickSize( tickerId, field, size) 
  end

  java_signature "void tickSnapshotEnd(int)"
  def tickSnapshotEnd(at) 
  end

  java_signature "void tickString(int,int,)"
  def tick(tickerId, tickType, value) 
  end

  java_signature "void updateAccountTime(String)"
  def updateAccountTime(timeStamp) 
  end

  java_signature "void updateAccountValue(String,String,String,String)"
  def updateAccountValue(key, value, currency, accountName) 
  end
end

class Gateway < IBGateway
  @@orders = {}
  @@port = 7496
  @@client_id = 1
  @@next_order_id = nil
  
  def connect
   @@client_socket.eConnect 'localhost', @@port, @@client_id
  end
  
  def disconnect 
   @@client_socket.eDisconnect if client_socket.isConnected 
  end
  
  java_signature "void orderStatus(int, String, int, int, double, int, int, double, int, String)"
  def orderStatus(orderId, status, filled, remaining, avgFillPrice, permId, parentId, lastFillPrice, clientId, whyHeld) 
    @@orders[orderId] = status
  end
  
  java_signature "void historicalData(int, String, double, double, double, double, int, int, double, boolean)"
  def historicalData(reqId, date, open, high, low, close, volume, count, wap, hasGaps) 
   return if ( date =~ ~'finished' )
    # def time_stamp = Date.parse("yyyyMMdd HH:mm:ss", date).format('yyyy-MM-dd HH:mm:ss:S')
  end
  
  def tickPrice(tickerId, field, price, canAutoExecute) 
    puts tickerId if canAutoExecute
  end
  
  def nextValidId(orderId) 
   @@next_order_id = orderId
  end
  
  def real_time_quotes(stock) 
    # client_socket.reqMktData( Quote.request_id(stock.symbol()), stock.contract, '', false )
  end
  
  def place_order(contract, order) 
    # client_socket.reqIds(client_id)
    # wait_for_response(100)
    # client_socket.placeOrder(next_order_id, contract, order)
    # log.info("[ORDER] type:$order.m_actionend symbol:$contract.m_symbolend quantity:$order.m_totalQuantityend price:$order.m_lmtPriceend")
    next_order_id
  end
  
  def wait_for_response(milliseconds=250) 
   sleep milliseconds
  end
  
  def order_filled(order_id) 
   orders[order_id] =~ /(?i)filled/
  end
  
  def order_cancelled(order_id) 
   orders[order_id] =~ /(?i)cancelled/
  end
  
  def cancel(order_id)
   client_socket.cancelOrder order_id
  end
end
