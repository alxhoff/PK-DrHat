import subprocess
import socket
import os
import errno

DebugOut_Ble = False

mac_list = [
    'A0:E6:F8:B6:10:00',
    'A0:E6:F8:B6:5D:05',
    'A0:E6:F8:B6:5B:83',
    'B8:27:EB:9A:9F:91',
    'B8:27:EB:5E:CB:FD',
    'B8:27:EB:7F:96:F9'
]

#values
lower_rssi_limit = -80
upper_rssi_limit = -30
norm_rssi_range = 100

#port we are listening on
HostIP = 1235
# IP and port of game on laptop
GameIP = "129.187.151.95"
GamePort = 1234

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind(('0.0.0.0', HostIP))
sock.setblocking(0)

def parse_hci_line(line):
    (host_part,rssi_part) = line.rstrip().split(', ')
    host_str = host_part
    host_bin = bytearray.fromhex(host_str.replace(':',' '))
    rssi_bin = int(rssi_part)
    return host_bin,rssi_bin,host_str

def normalize_rssi(raw_rssi):
    global lower_rssi_limit
    global upper_rssi_limit
    global norm_rssi_range
    norm = int(float(raw_rssi - lower_rssi_limit)/(upper_rssi_limit - lower_rssi_limit)*norm_rssi_range)
    if(norm > 100):
        return 100
    if(norm < 0):
        return 0

    return norm

def filter_out(host_str,rssi_norm):
    if( host_str not in mac_list):
        return True
    if( rssi_norm == 0):
        return True
    return False

def handle_hci_event(line):
    global DebugOut_Ble

    (host_bin, rssi_bin, host_str) = parse_hci_line(line.decode())
    rssi_norm = normalize_rssi(rssi_bin)

    if(DebugOut_Ble):
        print(line.decode().rstrip() + ' -> ', rssi_norm)

    if(filter_out(host_str,rssi_norm)):
        return

    print(line.decode().rstrip() + ' -> ', rssi_norm)

    packet =  bytearray([0x10]) + host_bin + bytearray([rssi_norm])

    if(DebugOut_Ble):
        print( packet.hex() )

    sock.sendto(packet, (GameIP, GamePort))

def parse_number( str ):
    return int(str)
                    #print('servo', int(data.decode()[2:]))
                # numlen = int(data[1])
                # num = []

                # for i in range(2, len(data)):
                #     num.append( data[i] + 48 )
                #     return

def listen_to_commands():
    data=''
    try:
        while True:
            data = sock.recv(1024)


            print(num)

            if(not data):
                return

            if(data[0] == 0x11):
                print('Beep: ', data)

                return

            if(data[0] == 0x12):
                print('led: ',data)
                print()
                return

            if(data[0] == 0x13): #servo
                print('servo:', data)

                return


            print('Unknown')

    except OSError as err:
#        print('Except')
        if err.errno == errno.EAGAIN or err.errno == errno.EWOULDBLOCK:
            pass # It is supposed to raise one of these exceptions


p=subprocess.Popen(['bash', '-c', '../ble/blescan.sh'],stdout=subprocess.PIPE )

while True:
    for line in p.stdout.readline(),'':
        if(line):
            handle_hci_event(line)

    listen_to_commands()

