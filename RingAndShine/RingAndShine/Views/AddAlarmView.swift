//
//  AddAlarmView.swift
//  RingAndShine
//
//  Created by Nayeli Castro on 4/22/25.
//

import SwiftUI

struct AddAlarmView: View {
    @ObservedObject var alarmManager: AlarmManager
    @State private var selectedTime: Date = Date()
    @State private var alarms: [Alarm] = []
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                DatePicker("Select Alarm Time", selection: $selectedTime, displayedComponents: [.hourAndMinute])
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                    .padding()
                
                Button(action: {
                    alarmManager.addAlarm(at: selectedTime)
                    dismiss()
                }) {
                    Text("Add Alarm")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                List {
                    ForEach(alarms) { alarm in
                        HStack {
                            Text(timeString(from: alarm.time))
                            Spacer()
                            Text(alarm.label)
                        }
                    }
                }
            }
            .navigationTitle("Alarms")
        }
    }
    
    func timeString(from date: Date) -> String {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
    
}

#Preview {
    AddAlarmView(alarmManager: AlarmManager())
}
