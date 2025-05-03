//
//  AlarmManager.swift
//  RingAndShine
//
//  Created by Nayeli Castro on 4/15/25.
//

import Foundation
import SwiftUI
import CocoaMQTT

class AlarmManager: ObservableObject {
    @Published var alarms: [Alarm] = []
    var lightstatus: [Int : String] = [0: "off", 1: "on"]
    let mqttClient = CocoaMQTT(clientID: "RingAndShine", host:"raspberrypi", port:1883)
    
    func addAlarm(at time: Date) {
        // round to the nearest minute to prevent millisecond mismatches
        let calendar = Calendar.current
        let roundedTime = calendar.date(from: calendar.dateComponents([.hour, .minute], from: time))!

        // check for existing alarm at same time
        if alarms.contains(where: {
            let existingTime = calendar.date(from: calendar.dateComponents([.hour, .minute], from: $0.time))!
            return existingTime == roundedTime
        }) {
            print("Alarm at this time already exists.")
            return
        }

        let newAlarm = Alarm(time: roundedTime, label: "New Alarm", isEnabled: true)
        alarms.append(newAlarm)
        NotificationManager.scheduleNotification(for: newAlarm)
    }

    
    func updateAlarm(alarm: Alarm) {
        if let index = alarms.firstIndex(where: { $0.id == alarm.id }) {
            alarms[index] = alarm

            NotificationManager.cancelNotification(for: alarm)

            if alarm.isEnabled {
                NotificationManager.scheduleNotification(for: alarm)
            }
        }
    }
    
    func deleteAlarm(at offsets: IndexSet) {
        alarms.remove(atOffsets: offsets)
    }
    
    func testConnection(){
        mqttClient.connect()
        print("Connected to mqtt client")
        //let dateFormatter = DateFormatter()

        //dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        //print(dateFormatter.string(from: Date()))
    }
    
    func sendOnMessage(){
        print("Sending message: ON" )
        mqttClient.publish("ringandshine/status", withString: "on")
    }
}
