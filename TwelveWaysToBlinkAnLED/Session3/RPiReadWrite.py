import RPi.GPIO as GPIO
import time

BUTTON = 22
LED = 23

GPIO.setmode(GPIO.BCM)
GPIO.setup(BUTTON, GPIO.IN)
GPIO.setup(LED, GPIO.OUT)

try:
    while True:
        inputValue = GPIO.input(BUTTON)
        if (GPIO.LOW == inputValue):
            GPIO.output(LED, GPIO.HIGH)
        else:
            GPIO.output(LED, GPIO.LOW)
        time.sleep(2)
except KeyboardInterrupt:
    GPIO.cleanup()
    
