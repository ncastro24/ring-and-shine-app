#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  cpsc514.py
#  
#  Copyright 2025  <cpsc514@raspberrypi>
#  
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#  
#  
import paho.mqtt.client as mqtt
import sys
import RPi.GPIO as GPIO
import time
import datetime
    
GPIO_pin = 18
print("hello world")
GPIO.setmode(GPIO.BCM)
GPIO.setup(GPIO_pin, GPIO.OUT)
pwm_led = GPIO.PWM(GPIO_pin, 100)

clientName = "RingAndShine"
serverAddress = "raspberrypi" #Change to a more unique name
mqttClient = mqtt.Client(clientName)
didPrintSubscribeMessage = False

def main(args):
    return 0
    
def connectionStatus(client, userdata, flags, rc):
    if rc == 0:
        print("Connection Success")
        mqttClient.subscribe("ringandshine/status")
    else:
        print("Connection fail with code {rc}")
        
def messageDecoder(client, userdata, msg):
    message = msg.payload.decode("utf-8")
    print("Message recieved: ", msg.payload)
    
    if message == "on":
        control_led(True)
        print("On")
        time.sleep(8)
        control_led(False)
        print("Off")
    else:
        control_led(False)
        print("Off")
    
def control_led(state):
    if state:
        GPIO.output(GPIO_pin, GPIO.HIGH)
        print("LED is on")
    else:
        GPIO.output(GPIO_pin, GPIO.LOW)
        print("LED is off")
        
def fade_on(duration):
    print("fading on")
    start_time = time.time()
    while time.time() - start_time < duration:
        elapsed_time = time.time() - start_time
        duty_cycle = (elapsed_time/duration) * 100
        pwm_led.ChangeDutyCycle(duty_cycle)
        time.sleep(0.01)
    print("done fading")
        
def set_alarm(hour, minute):
    target_time = datetime.time(hour, minute)
    now = datetime.datetime.now()
    target_datetime = datetime.datetime(now.year, now.month, now.day, hour, minute)
    
    if target_datetime < now:
        target_datetime += datetime.timedelta(days=1)
    
    print(f"LED alarm scheduled for {target_datetime.strftime('%Y-%m-%d %H:%M')}")
    return target_datetime

'''if __name__ == '__main__':
    import sys
    import RPi.GPIO as GPIO
    import time
    import datetime
    
    GPIO_pin = 18
        
    print("hello world")
    GPIO.setmode(GPIO.BCM)
    GPIO.setup(GPIO_pin, GPIO.OUT)
    pwm_led = GPIO.PWM(GPIO_pin, 100)
    
    try:
        # on, wait 5, off
        control_led(True)
        time.sleep(5)
        control_led(False)
        
        #fade on, turn off
        pwm_led.start(0)
        fade_on(5)
        control_led(False)
        
        #fade on at time, turn off
        hour = int(input("Enter the hour to set the alarm for (0-23): "))
        minute = int(input("Enter the minute to set the alarm for (0-59): ")) 
        alarm_time = set_alarm(hour, minute)
        
        while datetime.datetime.now() < alarm_time:
            time.sleep(1)
        fade_on(10)
        control_led(False)
        
    except:
        print("interrupt")
    finally:
        pwm_led.stop()
        GPIO.cleanup()
    
    print("goodbye world")
    
    sys.exit(main(sys.argv))'''

'''if __name__ == '__main__':
    try:
        control_led(True)
        print("On")
        time.sleep(5)
        control_led(False)
        print("Off")
    except:
        print("interrupt")
    finally:
        pwm_led.stop()
        GPIO.cleanup()'''

mqttClient.on_connect = connectionStatus
mqttClient.on_message = messageDecoder

mqttClient.connect(serverAddress, 1883)
mqttClient.loop_forever()
'''mosquitto_pub -h raspberrypi.local -t "ringandshine/status" -m "on"
'''
