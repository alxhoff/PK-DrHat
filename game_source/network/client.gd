extends Node

export (int) var UDP_PORT_SERVER = 1234
export (String) var UDP_ADDR_SERVER = "129.187.151.95"

export (int) var UDP_PORT_CLIENT = 1235
export (String) var UDP_ADDR_CLIENT = "129.187.151.129"

var socketUDP = PacketPeerUDP.new()

var last_test_packet = 0

const test_mac_1 = [0x00,0x00,0x00,0x00,0x00,0x01]
const test_mac_2 = [0x00,0x00,0x00,0x00,0x00,0x02]
const test_mac_3 = [0x00,0x00,0x00,0x00,0x00,0x03]
const test_mac_4 = [0x00,0x00,0x00,0x00,0x00,0x04]
const test_mac_5 = [0x00,0x00,0x00,0x00,0x00,0x05]
const test_mac_6 = [0x00,0x00,0x00,0x00,0x00,0x06]

const test_macs = [test_mac_1, test_mac_2, test_mac_3, test_mac_4, test_mac_5, test_mac_6]

const RSSI_PACKET_HEADER = 0x10
const BEEP_PACKET_HEADER = 0x11
const LED_PACKET_HEADER = 0x12
const SERVO_PACKET_HEADER = 0x13

func _ready():
	start_client()
	
#func _process(delta):
#	if last_test_packet > 200:
#		if socketUDP.is_listening():
#			socketUDP.set_dest_address(UDP_ADDR_SERVER, UDP_PORT_SERVER)
#
#			for test_dev in test_macs:
#				var test_packet = PoolByteArray()
#				test_packet.push_back(RSSI_PACKET_HEADER)
#
#				for byte in test_dev:
#					test_packet.push_back(byte)
#
#				test_packet.push_back(randi()%256+1)
#				socketUDP.put_packet(test_packet)
#
#		last_test_packet = 0
#	else:
#		last_test_packet += delta * 1000
#	pass
		
func add_value_to_packet(num_len, num, packet):
	var num_array = str(num)
	var num_array_len = num_array.length()
	if num_len > num_array_len:
		for i in range(num_len - num_array_len):
			num_array = "0" + num_array
	packet.push_back(num_len)
	for character in num_array:
		packet.push_back(character)
		
	return packet

func send_servo(value):  # Value between 0-100 to be displayed by the servo. Logic to be handled on the Pi
	if socketUDP.is_listening():
		socketUDP.set_dest_address(UDP_ADDR_CLIENT, UDP_PORT_CLIENT)
		var packet = PoolByteArray()
		packet.push_back(SERVO_PACKET_HEADER)
		
		packet = add_value_to_packet(3, value, packet)
			
		socketUDP.put_packet(packet)
		
func send_beep(frequency, period):  #period between fixed frequency beeps
	if socketUDP.is_listening():
		socketUDP.set_dest_address(UDP_ADDR_CLIENT, UDP_PORT_CLIENT)
		var packet = PoolByteArray()
		packet.push_back(BEEP_PACKET_HEADER)
		
		packet = add_value_to_packet(5, frequency, packet)
		packet = add_value_to_packet(5, period, packet)
			
		socketUDP.put_packet(packet)

func send_led(frequency, period):
	print("Sending led")
	if socketUDP.is_listening():
		socketUDP.set_dest_address(UDP_ADDR_CLIENT, UDP_PORT_CLIENT)
		var packet = PoolByteArray()
		packet.push_back(LED_PACKET_HEADER)
		
		packet = add_value_to_packet(5, frequency, packet)
		packet = add_value_to_packet(5, period, packet)
		
		socketUDP.put_packet(packet)
		
func start_client():
	if (socketUDP.listen(UDP_PORT_CLIENT, UDP_ADDR_SERVER) != OK):
		printt("Client cannot listen on port %d for server %s" % UDP_PORT_CLIENT, UDP_ADDR_SERVER)
		exit_client()
	else:
		printt("Client can listen on port %d" % UDP_PORT_CLIENT)
		
func exit_client():
	socketUDP.close()
	queue_free()