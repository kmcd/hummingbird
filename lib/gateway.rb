import com.ib.client.Contract
import com.ib.client.ContractDetails
import com.ib.client.EClientSocket
import com.ib.client.EWrapper
import com.ib.client.EWrapperMsgGenerator
import com.ib.client.Execution
import com.ib.client.Order
import com.ib.client.OrderState
import com.ib.client.UnderComp
  
class Gateway 
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

  java_signature "void nextValidId(int orderId)"
  def nextValidId(orderId) 
  end

  java_signature "void openOrder(int orderId,Contract contract,Order order,OrderState orderState)"
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

  java_signature "void tickString(int,int,String )"
  def tick(tickerId, tickType, value) 
  end

  java_signature "void updateAccountTime(String)"
  def updateAccountTime(timeStamp) 
  end

  java_signature "void updateAccountValue(String,String,String,String)"
  def updateAccountValue(key, value, currency, accountName) 
  end
end
