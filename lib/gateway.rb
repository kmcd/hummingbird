require 'forwardable'
require 'requestable'
require 'ib_gateway'

class Gateway < IbGateway
  attr_reader :port, :host
  include Requestable
  extend Forwardable
  def_delegators :client_socket, :eConnect, :eDisconnect, :connected?, 
    :placeOrder, :cancelOrder, :reqAllOpenOrders
    
  @@client_id = 0
  
  def initialize(port=4001, host='localhost')
    @port, @host = port, host
    connect
  end
  
  def connect
    eConnect host, port, @@client_id+=1
  end
  
  def disconnect
    eDisconnect if connected?
  end
end