//
//  Alarm.swift
//  RingAndShine
//
//  Created by Nayeli Castro on 4/15/25.
//

import Foundation
import SwiftUI

struct Alarm: Identifiable {
    let id = UUID()
    var time: Date
    var label: String
    var isEnabled: Bool
    var repeatDays: Set<Weekday> = []
    var snoozeDuration: Double = 5
    var sound: AlarmSound = .defaultSound
    var vibrationEnabled: Bool = false
    var color: Color = .blue
    var message: String = "Alarm went off!"
    enum Weekday: String, CaseIterable, Identifiable {
        var id: String { self.rawValue }
        case monday = "Mon"
        case tuesday = "Tues"
        case wednesday = "Wed"
        case thursday = "Thurs"
        case friday = "Fri"
        case saturday = "Sat"
        case sunday = "Sun"
    }
    enum AlarmSound: String, CaseIterable, Identifiable {
        var id: String { self.rawValue }
        case defaultSound = "Default"
        case birds = "Birds"
        case chimes = "Chimes"
        case waves = "Waves"
    }
}
