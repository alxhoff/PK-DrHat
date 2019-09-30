#!/usr/bin/python3

import subprocess
import socket
import os
import errno
import numpy
import threading
import time
from pwm import PWM
from periphery import GPIO

#### Constants

DebugOut_Ble = False
DebugCmd = False

#port we are listening on
HostIP = 1235
# IP and port of game on laptop
GameIP = "129.187.151.95"
GamePort = 1234

BeaconMacList = [
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

#~~~ Constants

#### Global Variables

sock = [] # socket for udp communication with game
servo = [] # servo object on helmet
leds = []
ble_scan_process = [] # handle for the ble scan process running in the background


class Servo:
    duty_min =  900000
    duty_max = 2790000
    duty_range = []
    pwm = []
    def __init__(self):
        self.duty_scale = (self.duty_max - self.duty_min) / 100
        self.pwm = PWM(0)
        self.pwm.export()
        self.pwm.inversed = False
        self.pwm.period = 20000000
        self.pwm.duty_cycle = 2000000
        self.pwm.enable = True


    def set_value(self, value):
        value =  numpy.clip(value,0,100)
        scaled = int(value* self.duty_scale)  + self.duty_min
        self.pwm.duty_cycle  = scaled

    def disable(self):
        self.pwm.enable = False




class Leds:
    leds = [GPIO(0, "out"), GPIO(1, "out")]
    period = 0.2
    frequency = 1
    thread =[]

    def __init__(self):
        self.thread = threading.Thread(target=self.background, args = (self,) )
        self.thread.start()

    def enable(self):
        for led in self.leds:
            led.write(True)

    def disable(self):
        for led in self.leds:
            led.write(False)

    def toggle(self):
        for led in self.leds:
            value = led.read()
            led.write(not value)

    def set_frequency(self, value):
        self.frequency = value

    def background(self, val):
        while True:
            self.enable()
            time.sleep(self.period)
            self.disable()
            time.sleep(self.frequency - self.period)





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
    if( host_str not in BeaconMacList):
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

    if(DebugOut_Ble):
        print(line.decode().rstrip() + ' -> ', rssi_norm)

    packet =  bytearray([0x10]) + host_bin + bytearray([rssi_norm])

    if(DebugOut_Ble):
        print( packet.hex() )

    sock.sendto(packet, (GameIP, GamePort))

def parse_number( data ):
    elements = [str(c) for c in data]
    #print(elements)
    s = ''.join(elements)
   # print(s)

    return int(s)
                #print('servo', int(data.decode()[2:]))
                # numlen = int(data[1])
                # num = []

                # for i in range(2, len(data)):
                #     num.append( data[i] + 48 )
                #     return

def parse_numbers( data ):
    nums = list()
    idx = 0
    while idx < len(data):
        size = data[idx]
        start = idx+ 1
        end = start + size
        num = parse_number(data[start : end])
        idx = end
        nums = nums + [num]

    return nums

def process_commands():
    global GameIP
    global GamePort
    data=''
    try:
        while True:
            data , source = sock.recvfrom(1024)
            GameIP = source[0]
            GamePort = source[1]
            if(not data):
                return

            if(data[0] == 0x11):
                frequency, period = parse_numbers(data[1:])
                if(DebugCmd):
                    print('Beep: ', data , ' -> (Frequ / period) : ', frequency, period)
                continue

            if(data[0] == 0x12):
                frequency, period = parse_numbers(data[1:])
                if(DebugCmd):
                    print('led: ' ,data , ' -> (Frequ / period) : ', frequency, period)
                continue

            if(data[0] == 0x13): #servo
                value = parse_numbers(data[1:])[0]
                if(DebugCmd):
                    print('servo:', data , ' -> ', value )
                servo.set_value(value)
                continue


            print('Unknown')

    except OSError as err:
#        print('Except')
        if err.errno == errno.EAGAIN or err.errno == errno.EWOULDBLOCK:
            pass # It is supposed to raise one of these exceptions

####################################################################

def process_ble_scan_output():
    global ble_scan_process
    for line in ble_scan_process.stdout.readline(),'':
        if(line):
            handle_hci_event(line)


sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind(('0.0.0.0', HostIP))
sock.setblocking(0)

servo = Servo()
leds = Leds()
leds.enable()

ble_scan_process = subprocess.Popen(['bash', '-c', '../ble/blescan.sh'],stdout=subprocess.PIPE )

gpio_in = GPIO(65, "in")

try:
    while True:
        process_ble_scan_output()
        process_commands()
        if(gpio_in.read()):
            leds.set_frequency(5)
        else:
            leds.set_frequency(2)

except Exception as e:
    traceback.print_exc()
    servo.disable()

