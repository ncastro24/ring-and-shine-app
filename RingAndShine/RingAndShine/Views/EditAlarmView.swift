//
//  EditAlarmView.swift
//  RingAndShine
//
//  Created by Nayeli Castro on 4/15/25.
//

import SwiftUI

struct EditAlarmView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var alarmManager: AlarmManager
    @State var alarm: Alarm
    
    let weekdays = Alarm.Weekday.allCases
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Alarm Time").foregroundColor(.white)){
                    DatePicker("Select Time", selection: $alarm.time, displayedComponents: .hourAndMinute).datePickerStyle(.wheel)
                }
                Section(header: Text("Label").foregroundColor(.white)){
                    TextField("Alarm Label", text: $alarm.label).textInputAutocapitalization(.words)
                }
                Section(header: Text("Status").foregroundColor(.white)){
                    Toggle("Enable Alarm", isOn: $alarm.isEnabled).tint(.green)
                }
                Section(header: Text("Repeat Days").foregroundColor(.white)){
                    ForEach(weekdays) { day in
                        Toggle(day.rawValue, isOn: Binding(
                            get: { alarm.repeatDays.contains(day)},
                            set: { isSelected in
                                if isSelected {
                                    alarm.repeatDays.insert(day)
                                } else {
                                    alarm.repeatDays.remove(day)
                                }
                            }))
                        .tint(.green)
                    }
                }
                Section(header: Text("Snooze Duration").foregroundColor(.white)){
                    Slider(value: $alarm.snoozeDuration, in: 1...30, step: 1) {
                        Text("Snooze Duration")
                    }
                    minimumValueLabel: {
                        Text("1")
                    }
                    maximumValueLabel: {
                        Text("30")
                    }
                    .foregroundStyle(.white)
                    Text("\(Int(alarm.snoozeDuration)) min")
                        .foregroundStyle(.green)
                }
                Section(header: Text("Alarm Sound").foregroundColor(.white)){
                    Picker("Sound", selection: $alarm.sound) {
                        ForEach(Alarm.AlarmSound.allCases) {sound in
                            Text(sound.rawValue)}
                    }
                }
                Section(header: Text("Vibration").foregroundColor(.white)){
                    Toggle("Enable Vibration", isOn: $alarm.vibrationEnabled)
                        .tint(.green)
                }
                Section(header: Text("Color").foregroundColor(.white)){
                    ColorPicker("Select Color", selection: $alarm.color, supportsOpacity: false)
                }
                Section(header: Text("Message (Test)").foregroundColor(.white)){
                    TextField("Message", text:$alarm.message)
                }
            }
            .navigationTitle("Edit Alarm")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        alarmManager.updateAlarm(alarm:alarm)
                        HapticManager.triggerSuccessHaptic()
                        dismiss()
                    }
                    .foregroundColor(.green)
                }
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    EditAlarmView(alarmManager: AlarmManager(), alarm: Alarm.init(time: Date(), label: "Test", isEnabled: true))
}
