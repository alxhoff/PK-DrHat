extends Node

const test_mac_1 = [0x00,0x00,0x00,0x00,0x00,0x01]
const test_mac_2 = [0x00,0x00,0x00,0x00,0x00,0x02]
const test_mac_3 = [0x00,0x00,0x00,0x00,0x00,0x03]
const test_mac_4 = [0x00,0x00,0x00,0x00,0x00,0x04]
const test_mac_5 = [0x00,0x00,0x00,0x00,0x00,0x05]
const test_mac_6 = [0x00,0x00,0x00,0x00,0x00,0x06]

const test_macs = [test_mac_1, test_mac_2, test_mac_3, test_mac_4, test_mac_5, test_mac_6]

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
#		print("Data recv on port %d from ip %s" % [PORT_CLIENT, IP_CLIENT])
		if data:
			process_packet(data)
		
func process_packet(packet): #Rssi packet is 2 bytes, first byte is device id, second is rssi 0-255
	var bt_device = packet.subarray(0,5)
	var bt_rssi = packet.subarray(6,6)[0]
#	print("BT DEV: %x:%x:%x:%x:%x:%x RSSI: %d" % [bt_device[0],bt_device[1],bt_device[2],bt_device[3],bt_device[4],bt_device[5], bt_rssi])
	bt_rssi = float(bt_rssi) / 255 * 100.0
	var device_id = match_device(bt_device)
	emit_signal("new_bt_rssi", device_id, round(bt_rssi))
	
func match_device(mac_addr):
	for i in range(0, test_macs.size()):
		var hit = true
		for j in range(6):
			if mac_addr[j] != test_macs[i][j]:
				hit = false
				break
		if hit:
			return i
	
func start_server():
	if(socketUDP.listen(UDP_PORT_SERVER) != OK):
		printt("Error listening on port %d" % UDP_PORT_SERVER)
	else:
		printt("Listening on port %d" % UDP_PORT_SERVER)
		
func exit_tree():
	socketUDP.close()
	queue_free()