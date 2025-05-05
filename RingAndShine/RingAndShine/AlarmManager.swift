//
//  AlarmManager.swift
//  RingAndShine
//
//  Created by Nayeli Castro on 4/15/25.
//

import Foundation
import CocoaMQTT
import Combine
import SwiftUI

class AlarmManager: ObservableObject, CocoaMQTTDelegate {
    static let shared = AlarmManager()

    @Published var alarms: [Alarm] = []
    var lightstatus: [Int : String] = [0: "off", 1: "on"]
    let mqttClient: CocoaMQTT

    private init() {
        mqttClient = CocoaMQTT(clientID: "RingAndShine-\(UUID().uuidString.prefix(6))", host: "raspberrypi", port: 1883)
        mqttClient.delegate = self
    }

    func addAlarm(at time: Date) {
        let calendar = Calendar.current
        let roundedTime = calendar.date(from: calendar.dateComponents([.hour, .minute], from: time))!

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

    func testConnection() {
        mqttClient.connect()
        print("Connecting to MQTT client...")
    }

    func sendOnMessage() {
        print("Sending message: ON")
        mqttClient.publish("ringandshine/status", withString: "on")
    }

    // MARK: - MQTT Delegate Methods

    func mqtt(_ mqtt: CocoaMQTT, didConnect host: String, port: Int) {
        print("Connected to \(host):\(port)")
    }

    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("Connection acknowledged: \(ack)")
        mqtt.subscribe("ringandshine/status")
    }

    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        guard let payload = message.string else {
            print("Received message with no payload.")
            return
        }

        print("Received message '\(payload)' on topic: \(message.topic)")

        switch payload.lowercased() {
        case "on":
            handleLightStatusChange(to: "on")
        case "off":
            handleLightStatusChange(to: "off")
        default:
            print("Unhandled message payload: \(payload)")
        }
    }

    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("Published message '\(message.string ?? "")' with id \(id)")
    }

    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("Publish acknowledged for id: \(id)")
    }

    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
        print("Subscribed to topics: \(success.allKeys)")
        if !failed.isEmpty {
            print("Failed to subscribe to topics: \(failed)")
        }
    }

    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) {
        print("Unsubscribed from topics: \(topics)")
    }

    func mqttDidPing(_ mqtt: CocoaMQTT) {
        print("MQTT did ping")
    }

    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        print("MQTT did receive pong")
    }

    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        if let error = err {
            print("Disconnected with error: \(error.localizedDescription)")
        } else {
            print("Disconnected cleanly")
        }
    }

    private func handleLightStatusChange(to status: String) {
        lightstatus[0] = status
        print("Light status changed to: \(status)")
    }
}
