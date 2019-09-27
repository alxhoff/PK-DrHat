extends Node

const test_mac_1 = [0xA0,0xE6,0xF8,0xB6,0x10,0x00]
const test_mac_2 = [0xA0,0xE6,0xF8,0xB6,0x5D,0x05]
const test_mac_3 = [0xA0,0xE6,0xF8,0xB6,0x5B,0x83]
const test_mac_4 = [0xB8,0x27,0xEB,0x9A,0x9F,0x91]
const test_mac_5 = [0xB8,0x27,0xEB,0x5E,0xCB,0xFD]
const test_mac_6 = [0xB8,0x27,0xEB,0x7F,0x96,0xF9]

const test_macs = [test_mac_1, test_mac_2, test_mac_3, test_mac_4, test_mac_5, test_mac_6]

export (int) var UDP_PORT_SERVER = 1234
export (String) var UDP_ADDR_SERVER = "127.0.0.1"
export (int) var UDP_PORT_CLIENT = 1235

const RSSI_PACKET_HEADER = 0x10

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
	var header = packet.subarray(0,0)[0]
	if header == RSSI_PACKET_HEADER:
		var bt_device = packet.subarray(1,6)
		var bt_rssi = packet.subarray(7,7)[0]
		print("BT DEV: %x:%x:%x:%x:%x:%x RSSI: %d" % [bt_device[0],bt_device[1],bt_device[2],bt_device[3],bt_device[4],bt_device[5], bt_rssi])
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