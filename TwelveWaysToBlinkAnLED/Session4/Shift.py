import RPi.GPIO as GPIO
import time

# Pin connected to ST_CP of 74HC595
latchPin = 23
# Pin connected to SH_CP of 74HC595
clockPin = 24
# Pin connected to DS of 74HC595
dataPin = 25

# set pins to output because they are addressed in the main loop
GPIO.setmode(GPIO.BCM)
GPIO.setup(latchPin, GPIO.OUT)
GPIO.setup(clockPin, GPIO.OUT)
GPIO.setup(dataPin, GPIO.OUT)

def shiftOut(val, bits):
    # print 'value = ', val
    # pull latch pin low while pushing data into shift register
    GPIO.output(latchPin, GPIO.LOW)

    # push data bits one at a time
    for i in range(0, bits):
        bit = 1 & (val >> ((bits - 1) - i))
        # print 'bit = ', bit
	GPIO.output(dataPin, bit)
        # pulse clock pin to advance bits in shift register
        GPIO.output(clockPin, GPIO.HIGH)
        GPIO.output(clockPin, GPIO.LOW)

    # pull latch pin high to push all bits to output
    GPIO.output(latchPin, GPIO.HIGH)

def gray(n):
    return n^(n//2)

try:
    while True:
        # count up routine
        for j in range(0, 16):
            shiftOut(gray(j), 4)
            time.sleep(0.5)
except KeyboardInterrupt:
      GPIO.cleanup()
