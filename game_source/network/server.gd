extends Node

export (int) var UDP_PORT_SERVER = 1234
export (String) var UDP_ADDR_SERVER = "127.0.0.1"
export (int) var UDP_PORT_CLIENT = 1235

var socketUDP = PacketPeerUDP.new()

signal new_bt_rssi(device, strength)

func _ready():
	start_server()
	
func _process(delta):
	if socketUDP.get_available_packet_count() > 0:
		var data = socketUDP.get_packet()
		var IP_CLIENT = socketUDP.get_packet_ip()
		var PORT_CLIENT = socketUDP.get_packet_port()
		print("Data recv on port %d from ip %s" % [PORT_CLIENT, IP_CLIENT])
		if data:
			process_packet(data)
		
func process_packet(packet): #Rssi packet is 2 bytes, first byte is device id, second is rssi 0-255
	var bt_device = packet.subarray(0,5)
	var bt_rssi = packet.subarray(6,6)[0]
	print("BT DEV: %x:%x:%x:%x:%x:%x RSSI: %d" % [bt_device[0],bt_device[1],bt_device[2],bt_device[3],bt_device[4],bt_device[5], bt_rssi])
	bt_rssi = float(bt_rssi) / 255 * 100.0
	emit_signal("new_bt_rssi", bt_device, round(bt_rssi))
	
func start_server():
	if(socketUDP.listen(UDP_PORT_SERVER) != OK):
		printt("Error listening on port %d" % UDP_PORT_SERVER)
	else:
		printt("Listening on port %d" % UDP_PORT_SERVER)
		
func exit_tree():
	socketUDP.close()
	queue_free()