//
//  NotificationManager.swift
//  RingAndShine
//
//  Created by Nayeli Castro on 4/20/25.
//

import Foundation
import UserNotifications

class NotificationManager {
  
    static func checkAuthorization(completion: @escaping (Bool) -> Void) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                completion(true)
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { allowed, _ in
                    completion(allowed)
                }
            default:
                completion(false)
            }
        }
    }

    static func scheduleNotification(for alarm: Alarm) {
        guard alarm.isEnabled else { return } // Only notify if enabled

        let content = UNMutableNotificationContent()
        content.title = "Alarm"
        content.body = alarm.label
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: AudioSounds.bell.resource))

        // Extract date components from alarm time
        let components = Calendar.current.dateComponents([.hour, .minute], from: alarm.time)

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        let request = UNNotificationRequest(
            identifier: alarm.id.uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for: \(components)")
            }
        }
    }

    static func cancelNotification(for alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.id.uuidString])
    }
}
