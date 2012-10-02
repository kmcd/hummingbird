require 'java'
require 'ib_gateway'

class Gateway < IbGateway
  attr_reader :port, :host
  @@client_id = 0
  
  def initialize(port=4001, host='localhost')
    @port, @host = port, host
  end
  
  def connect
    client_socket.eConnect host, port, @@client_id+=1
  end
  
  def disconnect
    client_socket.eDisconnect if client_socket.connected?
  end
end