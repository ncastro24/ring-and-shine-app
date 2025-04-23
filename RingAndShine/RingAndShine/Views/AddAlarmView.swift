//
//  AddAlarmView.swift
//  RingAndShine
//
//  Created by Nayeli Castro on 4/22/25.
//

import SwiftUI

struct AddAlarmView: View {
    @State private var selectedTime: Date = Date()
    @State private var alarms: [Alarm] = []
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                DatePicker("Select Alarm Time", selection: $selectedTime, displayedComponents: [.hourAndMinute])
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                    .padding()
                
                Button(action: {
                    addAlarm(at: selectedTime)
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
}

#Preview {
    AddAlarmView()
}
