require 'forwardable'
require 'ib_gateway'
require 'redis'

class Gateway < IbGateway
  attr_reader :port, :host
  extend Forwardable
  def_delegators :client_socket, :eConnect, :eDisconnect, :connected?,
    :placeOrder, :cancelOrder, :reqAllOpenOrders
    
  def initialize(port=4001, host='localhost')
    @port, @host = port, host
    connect
  end
  
  def connect
    eConnect host, port, client_id
  end
  
  def disconnect
    eDisconnect if connected?
  end
  
  def client_id
    @client_id ||= Redis.new.incr :ib_gateway_client_id
  end
end