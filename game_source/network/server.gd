extends Node

export (int) var UDP_PORT_SERVER = 1234
export (String) var UDP_ADDR_SERVER = "127.0.0.1"

export (int) var UDP_PORT_CLIENT = 1235

var socketUDP = PacketPeerUDP.new()

func _ready():
	start_server()
	
func _process(delta):
	if socketUDP.get_available_packet_count() > 0:
		var data = socketUDP.get_packet()
		var IP_CLIENT = socketUDP.get_packet_ip()
		var PORT_CLIENT = socketUDP.get_packet_port()
		if(data.get_string_from_ascii() == "quit"):
			exit_tree()
		else:
			print("Data recv: %s, on port %d from ip %s" % [data.get_string_from_ascii(), PORT_CLIENT, IP_CLIENT])
			
	
func start_server():
	if(socketUDP.listen(UDP_PORT_SERVER) != OK):
		printt("Error listening on port %d" % UDP_PORT_SERVER)
	else:
		printt("Listening on port %d" % UDP_PORT_SERVER)
		
func exit_tree():
	socketUDP.close()
	queue_free()