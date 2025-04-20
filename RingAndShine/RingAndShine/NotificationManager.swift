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
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { allowed, error in
          completion(allowed)
        }
      default:
        completion(false)
      }
    }
  }
  
  static func scheduleNotification(seconds: TimeInterval, title: String, body: String) {
    let notificationCenter = UNUserNotificationCenter.current()
    // remove all notification
    notificationCenter.removeAllDeliveredNotifications()
    notificationCenter.removeAllPendingNotificationRequests()
    // set up content
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = .default
    content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: AudioSounds.bell.resource))
    // trigger
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
    // create request
    let request = UNNotificationRequest(identifier: "my-notification", content: content, trigger: trigger)
    // add the notification to the center
    notificationCenter.add(request)
  }
}
