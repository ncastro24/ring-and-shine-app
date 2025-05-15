# ring-and-shine-app
 
Made by referencing these videos: [1](https://www.youtube.com/watch?v=1b8H7UXJ6Co) , [2](https://www.youtube.com/watch?v=6m3H_SLZp5k&list=PLpSG4DtJWIHW1BHjqM6xqEF1jw4h1noYj&index=1)

For CPSC 514 Final Project

Group Members:
Briana Craig, Hazel Caruthers, Nayeli Castro, Tiffany Le

Features:

- Alarm that goes off at exact phone time with iOS notification and sound
- Preventative measures for duplicate alarms
- 24 and 12 hour time
- Lighting system through raspberry pi 5 and breadboard: currently, only function is to turn on when the alarm goes off -- plans to add more functionality
- Simple publishing and subscribing to a MQTT broker -- we use Paho (subscriber - python), CocoaMQTT (publisher - iOS), and  Mosquitto (broker - raspberry pi)

[Our presentation (Chapman University only)](https://docs.google.com/presentation/d/1MkAyVf9v6-JepvmVopanJOJ7yBFCqwsbM8PKcG4X6yM/edit?usp=sharing)

Files/Folders:

- cpsc514_main.py : the python file that goes into the raspberry pi. Controls the light on the breadboard and controls the subscriber in our MQTT system. Raspberry pi needs at least Paho installed and imported for this file to run.
- Ring and Shine : entire project file for the alarm app. Written in Swift and best viewed on Xcode and its iOS 17 simulator. CocoaPods should be installed on the workplace where the program will run. Please open the RingAndShine.xcworkplace file to run the project rather than the RingAndShine.xcodeproj file, as that is the file with the necessary Pods from CocoaMQTT imported. 


