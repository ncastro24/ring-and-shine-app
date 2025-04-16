//
//  SettingsView.swift
//  RingAndShine
//
//  Created by Nayeli Castro on 4/15/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var settings: Settings
    @ObservedObject var alarmManager: AlarmManager
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Time Format").foregroundColor(.white)) {
                    Toggle("Use 24-Hour format", isOn: $settings.use24HourFormat)
                        .tint(.green)
                }
                Section(header: Text("Connection").foregroundColor(.white)) {
                    Button {
                        alarmManager.testConnection()
                        HapticManager.triggerSuccessHaptic()
                    } label: {
                        Text("Test Connection to Pi").foregroundStyle(.green)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    SettingsView(settings: Settings(), alarmManager: AlarmManager())
}
