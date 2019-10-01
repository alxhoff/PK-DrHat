extends Node

const test_mac_1 = [0xB8,0x27,0xEB,0x9A,0x9F,0x91]
const test_mac_2 = [0xA0,0xE6,0xF8,0xB6,0x5D,0x05]
const test_mac_3 = [0xA0,0xE6,0xF8,0xB6,0x5B,0x83]
const test_mac_4 = [0xA0,0xE6,0xF8,0xB6,0x10,0x00]
const test_mac_5 = [0xB8,0x27,0xEB,0x5E,0xCB,0xFD]
const test_mac_6 = [0xB8,0x27,0xEB,0x7F,0x96,0xF9]

const DEV_COUNT = 6
var signal_averages = []

const SIGNAL_AVERAGE_COUNT = 10
var SIGNAL_TIME_AVERAGE_TOTAL = SIGNAL_AVERAGE_COUNT * (SIGNAL_AVERAGE_COUNT + 1)/2

const test_macs = [test_mac_1, test_mac_2, test_mac_3, test_mac_4, test_mac_5, test_mac_6]

export (int) var UDP_PORT_SERVER = 1234
export (int) var UDP_PORT_CLIENT = 1235

const RSSI_PACKET_HEADER = 0x10
const DR_ING_LETTERS_HEADER = 0x16

var socketUDP = PacketPeerUDP.new()

signal new_bt_rssi(device, strength)
signal letters_updated(count)

func _ready():
	init_averages()
	start_server()
	
func init_averages():
	for i in range(DEV_COUNT):
		signal_averages.push_back([])
		for j in range(SIGNAL_AVERAGE_COUNT):
			signal_averages[i].push_back(0)
	
func _process(delta):
	if socketUDP.get_available_packet_count() > 0:
		var data = socketUDP.get_packet()
		var IP_CLIENT = socketUDP.get_packet_ip()
		var PORT_CLIENT = socketUDP.get_packet_port()
#		print("Data recv on port %d from ip %s" % [PORT_CLIENT, IP_CLIENT])
		if data:
			process_packet(data)
	
func process_packet(packet): #Rssi packet is 2 bytes, first byte is device id, second is rssi 0-255
	var header = packet.subarray(0,0)[0]
	if header == RSSI_PACKET_HEADER or header == DR_ING_LETTERS_HEADER:
		var bt_device = packet.subarray(1,6)

		if header == RSSI_PACKET_HEADER:
			var bt_rssi = packet.subarray(7,7)[0]
			print("BT DEV: %x:%x:%x:%x:%x:%x RSSI: %d" % [bt_device[0],bt_device[1],bt_device[2],bt_device[3],bt_device[4],bt_device[5], bt_rssi])
			bt_rssi = float(bt_rssi)
			var device_id = match_device(bt_device)
			if device_id >= 0:
				bt_rssi = round(bt_rssi)
				signal_averages[device_id].pop_front()
				signal_averages[device_id].push_back(bt_rssi)
				var average = 0
	
				for i in range(signal_averages[device_id].size()):
					average += signal_averages[device_id][i]
				average /= float(signal_averages[device_id].size())
				emit_signal("new_bt_rssi", device_id, bt_rssi)
		
		elif header == DR_ING_LETTERS_HEADER:
			var letters = packet.subarray(2,7)
			var count = 0
			if letters[0]:
				count = 1
			if letters[1]:
				count = 2
			if letters[2]:
				count = 3
			if letters[3]:
				count = 4
			if letters[4]:
				count = 5
			if letters[5]:
				count = 6 
			emit_signal("letters_updated", count)
	
func match_device(mac_addr):
	for i in range(0, test_macs.size()):
		var hit = true
		for j in range(6):
			if mac_addr[j] != test_macs[i][j]:
				hit = false
				break
		if hit:
			return i
	return -1
	
func start_server():
	if(socketUDP.listen(UDP_PORT_SERVER) != OK):
		printt("Error listening on port %d" % UDP_PORT_SERVER)
	else:
		printt("Listening on port %d" % UDP_PORT_SERVER)
		
func exit_tree():
	socketUDP.close()
	queue_free()