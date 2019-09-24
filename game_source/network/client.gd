extends Node

export (int) var UDP_PORT_SERVER = 1234
export (String) var UDP_ADDR_SERVER = "127.0.0.1"

export (int) var UDP_PORT_CLIENT = 1235
export (String) var UDP_ADDR_CLIENT = "127.0.0.1"

var socketUDP = PacketPeerUDP.new()

var last_test_packet = 0

const test_mac_1 = [0x00,0x00,0x00,0x00,0x00,0x01]
const test_mac_2 = [0x00,0x00,0x00,0x00,0x00,0x02]
const test_mac_3 = [0x00,0x00,0x00,0x00,0x00,0x03]
const test_mac_4 = [0x00,0x00,0x00,0x00,0x00,0x04]
const test_mac_5 = [0x00,0x00,0x00,0x00,0x00,0x05]
const test_mac_6 = [0x00,0x00,0x00,0x00,0x00,0x06]

const test_macs = [test_mac_1, test_mac_2, test_mac_3, test_mac_4, test_mac_5, test_mac_6]

func _ready():
	start_client()
	
func _process(delta):
	if last_test_packet > 1000:
		if socketUDP.is_listening():
			socketUDP.set_dest_address(UDP_ADDR_SERVER, UDP_PORT_SERVER)
			
			for test_dev in test_macs:
				var test_packet = PoolByteArray()

				for byte in test_dev:
					test_packet.push_back(byte)
		
				test_packet.push_back(randi()%256+1)
				socketUDP.put_packet(test_packet)
		
		last_test_packet = 0
	else:
		last_test_packet += delta * 1000
	
func start_client():
	if (socketUDP.listen(UDP_PORT_CLIENT, UDP_ADDR_SERVER) != OK):
		printt("Client cannot listen on port %d for server %s" % UDP_PORT_CLIENT, UDP_ADDR_SERVER)
		exit_client()
	else:
		printt("Client can listen on port %d" % UDP_PORT_CLIENT)
		
func exit_client():
	socketUDP.close()
	queue_free()