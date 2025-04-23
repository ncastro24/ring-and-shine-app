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
    @State private var isPressed = false
    @State private var showWarning = true
    @Environment (\.scenePhase) var scenePhase
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Time Format").foregroundColor(.white)) {
                    Toggle("Use 24-Hour format", isOn: $settings.use24HourFormat)
                        .tint(.green)
                }
                Section(header: Text("Connection").foregroundColor(.white)) {
                    Button ("Test Connection to Pi", action: {
                        self.isPressed.toggle()
                        alarmManager.testConnection()
                        
                        HapticManager.triggerSuccessHaptic()
                        NotificationManager.scheduleNotification(seconds: 5, title: "Test Message", body: "This is a test notification")
                    })
                    .scaleEffect(isPressed ? 1.1 : 1.0)
                    .animation(.easeInOut, value: isPressed)
                    .foregroundColor(.green)
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
        .onChange(of: scenePhase){
            if scenePhase == .active {
                NotificationManager.checkAuthorization { authorized in
                    showWarning = !authorized
                }
            }
        }
    }
}

#Preview {
    SettingsView(settings: Settings(), alarmManager: AlarmManager())
}
