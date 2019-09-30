cd /sys/class/gpio/
echo 1 > /sys/class/gpio/export; echo out > /sys/class/gpio/gpio1/direction
echo 0 > /sys/class/gpio/export; echo out > /sys/class/gpio/gpio0/direction
echo 3 > /sys/class/gpio/export; echo out > /sys/class/gpio/gpio3/direction
echo 65 > /sys/class/gpio/export; echo in > /sys/class/gpio/gpio65/direction
echo 66 > /sys/class/gpio/export; echo in > /sys/class/gpio/gpio66/direction
echo 7 > /sys/class/gpio/export; echo in > /sys/class/gpio/gpio7/direction
echo 8 > /sys/class/gpio/export; echo in > /sys/class/gpio/gpio8/direction
echo 9 > /sys/class/gpio/export; echo in > /sys/class/gpio/gpio9/direction
echo 10 > /sys/class/gpio/export; echo in > /sys/class/gpio/gpio10/direction
echo 17 > /sys/class/gpio/export; echo in > /sys/class/gpio/gpio17/direction
