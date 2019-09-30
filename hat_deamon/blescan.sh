#!/bin/bash



# define constants
# =======================================================================

BLUETOOTH_DEVICE=hci0
#sudo hcitool -i hcix cmd <OGF> <OCF> <No. Significant Data Octets> <iBeacon Prefix> <UUID> <Major> <Minor> <Tx Power> <Placeholder Octets>

#OGF = Operation Group Field = Bluetooth Command Group = 0x08
#OCF = Operation Command Field = HCI_LE_Set_Advertising_Data = 0x0008
#No. Significant Data Octets (Max of 31) = 1E (Decimal 30)

OGF="0x08"    # Bluetooth Command Group = 0x08
OCF="0x0008"  # HCI_LE_Set_Advertising_Data = 0x0008

OCF_ADV="0x0008" 
OCF_SCAN_CFG="0x000B" # Config Scan
OCF_SCAN_EN="0x000C"  # Enable Scan




# define functions
# =======================================================================


# 0x000C 0x01 (scan enabled true)  0x00 (filter duplicates false)
function scan_enable(){ 
	sudo hcitool -i $BLUETOOTH_DEVICE cmd ${OGF} ${OCF_SCAN_EN} 0x01 0x00 > /dev/null
	# sudo hcitool -i hci0 cmd 0x08 0x000C 0x01 0x00    # WORKS!
}

# set scan parameter
# 0x00 passive 0x01 active
# interval: 0x00FF  : val * 0.625 ms
# window: 0x00FF : should be less or equal to interval
# address: 0x01  (random address)
# accept: 0x00 accept all advertisments
function scan_config(){ 
	sudo hcitool -i $BLUETOOTH_DEVICE cmd ${OGF} ${OCF_SCAN_CFG} 0x00 0xFF 0x00 0xFF 0x00 0x01 0x00 > /dev/null  # LSB first
	# sudo hcitool -i hci0 cmd 0x08 0x000B 00 FF 00 FF 00 01 00 
	# sudo hcitool -i hci0 cmd 0x08 0x000B 0x00 0x05 0x00 0x05 0x00 0x01 0x00 
}



# parse raw data
function parse_mac {
	# MAC address is byte 8 to 13 but
	# hcidump displays bytes in reverse order... yay
    MAC=`echo $1 | sed 's/^.\{21\}\(..\) \(..\) \(..\) \(..\) \(..\) \(..\).*$/\6:\5:\4:\3:\2:\1/'`
}

function parse_rssi {
      LEN=$[${#1} - 2]
      RSSI=`echo $1 | sed "s/^.\{$LEN\}\(.\{2\}\).*$/\1/"`
      RSSI=`echo "ibase=16; $RSSI" | bc`
      RSSI=$[RSSI - 256]
}

function parse_rawevent {
    packet=""
    capturing=""
    count=0
    while read line
    do
        count=$[count + 1]
        if [ "$capturing" ]; then
            if [[ $line =~ ^[0-9a-fA-F]{2}\ [0-9a-fA-F] ]]; then
                packet="$packet $line"
            else
                #echo "PACKET: $packet"
                if [[ $packet =~ ^04\ 3E\ ..\ 02\ 01\ .* ]]; then
                    parse_mac "$packet"
                    parse_rssi "$packet"
                    echo "$MAC, $RSSI"
                fi
                capturing=""
                packet=""
            fi
        fi

        if [ ! "$capturing" ]; then
            if [[ $line =~ ^\> ]]; then
                packet=`echo $line | sed 's/^>.\(.*$\)/\1/'`
                capturing=1
            fi
        fi
    done
}




# execute
# =======================================================================


# initialize the host controller
sudo hciconfig $BLUETOOTH_DEVICE up

# disable advertising 
sudo hciconfig $BLUETOOTH_DEVICE noleadv

# stop the dongle looking for other Bluetooth devices
sudo hciconfig $BLUETOOTH_DEVICE noscan


scan_config

scan_enable

sudo hcidump --raw | parse_rawevent


# sudo btmgmt find -l    # one liner

echo "complete"

exit 0






# Old Stuff
# =======================================================================
#
# function parse_event(){
# 	while read address
# 	do
# 	    read RSSI
# 	    timestamp=`date`
# 	    #echo "$timestamp,$address,$RSSI"
# 	    echo "$address,$RSSI"
# 	done
# }

# function read_rssi(){
# 	# sudo hcidump -a | egrep 'RSSI|bdaddr' | cut -f 8 -d ' ' 
# 	# sudo hcidump -a | grep -A 6 '> HCI Event: LE Meta Event (0x3e)' | grep -oz 'RSSI|bdaddr'
# 	# sudo hcidump --raw | grep -oP '^> (.*)$'  
# 	# sudo hcidump -a | grep -oP--line-buffered 'RSSI: (-\d+)|bdaddr'
# 	sudo hcidump -a | egrep --line-buffered 'RSSI|bdaddr' | cut -f 8 -d ' ' | parse_event
# 	#sudo hcidump -a | grep -A 6 '> HCI Event: LE Meta Event (0x3e)' | egrep 'RSSI|bdaddr' | cut -f 8 -d ' ' | parse_event
# }


