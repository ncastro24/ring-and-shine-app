//
//  AlarmManager.swift
//  RingAndShine
//
//  Created by Nayeli Castro on 4/15/25.
//

import Foundation
import SwiftUI

class AlarmManager: ObservableObject {
    @Published var alarms: [Alarm] = []
    
    func addAlarm(){
        let newAlarm = Alarm(time: Date(), label: "New Alarm", isEnabled: true)
        alarms.append(newAlarm)
    }
    
    func updateAlarm(alarm: Alarm) {
        guard let index = alarms.firstIndex(where: {$0.id == alarm.id}) else {return}
        alarms[index] = alarm
    }
    
    func deleteAlarm(at offsets: IndexSet) {
        alarms.remove(atOffsets: offsets)
    }
}
