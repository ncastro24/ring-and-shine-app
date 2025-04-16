//
//  AlarmDetailView.swift
//  RingAndShine
//
//  Created by Nayeli Castro on 4/15/25.
//

import SwiftUI

struct AlarmDetailView: View {
    let alarm: Alarm
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {
                    Text("Alarm Details")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text("Time: \(formattedTime(alarm.time))")
                        .foregroundStyle(.white)
                    Text("Label: \(alarm.label)")
                        .foregroundStyle(.white)
                    Text("Status: \(alarm.isEnabled ? "Enabled" : "Disabled")")
                        .foregroundStyle(.white)
                    Text("Repeat Days: \(daysString(for: alarm.repeatDays))")
                        .foregroundStyle(.white)
                    Text("Snooze: \(Int(alarm.snoozeDuration)) min")
                        .foregroundStyle(.white)
                    Text("Sound: \(alarm.sound.rawValue)")
                        .foregroundStyle(.white)
                    Text("Vibration: \(alarm.vibrationEnabled ? "On" : "Off")")
                        .foregroundStyle(.white)
                    Text("Message: \(alarm.message)")
                        .foregroundStyle(.white)
                    
                    VStack(alignment: .leading, spacing: 10){
                        Text("Notification Preview")
                            .font(.headline)
                            .foregroundColor(.white)
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 80)
                            .overlay(
                                VStack {
                                    Text("ALARM")
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white)
                                    Text("\(alarm.label) - \(formattedTime(alarm.time))")
                                        .foregroundStyle(.white)
                                        .font(.caption)
                                })
                    }
                    Spacer()
                }
                .padding()
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    private func daysString(for days: Set<Alarm.Weekday>) -> String {
        if days.isEmpty {
            return "None"
        } else {
            return days.map {$0.rawValue}.joined(separator: ", ")
        }
    }
    private func nextOccurence(for alarm: Alarm) -> String {
        return "Tomorrow"
    }
}

#Preview {
    AlarmDetailView(alarm: Alarm.init(time: Date(), label: "Test", isEnabled: true))
}
