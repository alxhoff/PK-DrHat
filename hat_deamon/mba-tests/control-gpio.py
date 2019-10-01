#!/usr/bin/python3
import time
from periphery import GPIO

# Open GPIO 10 with input direction
gpio_in = GPIO(65, "in")
# Open GPIO 12 with output direction
gpio_out = GPIO(1, "out")
gpio_beep = GPIO(3, 'out')


while True:
    value = gpio_in.read()
    gpio_beep.write(value)

    time.sleep(0.1)

    gpio_beep.write(False)

    time.sleep(1)



gpio_in.close()
gpio_out.close()