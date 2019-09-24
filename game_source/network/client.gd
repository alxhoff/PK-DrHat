extends Node

export (int) var UDP_PORT_SERVER = 1234
export (String) var UDP_ADDR_SERVER = "127.0.0.1"

export (int) var UDP_PORT_CLIENT = 1235
export (String) var UDP_ADDR_CLIENT = "127.0.0.1"

var socketUDP = PacketPeerUDP.new()

func _ready():
	start_client()
	
func _process(delta):
	if socketUDP.is_listening():
		socketUDP.set_dest_address(UDP_ADDR_SERVER, UDP_PORT_SERVER)
		socketUDP.put_packet("Test message".to_ascii())
	
func start_client():
	if (socketUDP.listen(UDP_PORT_CLIENT, UDP_ADDR_SERVER) != OK):
		printt("Client cannot listen on port %d for server %s" % UDP_PORT_CLIENT, UDP_ADDR_SERVER)
		exit_client()
	else:
		printt("Client can listen on port %d" % UDP_PORT_CLIENT)
		
func exit_client():
	socketUDP.close()
	queue_free()