//
//  ContentView.swift
//  RingAndShine
//
//  Created by Nayeli Castro on 4/15/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var alarmManager = AlarmManager()
    @StateObject private var settings = Settings()
    
    @State private var selectedAlarm: Alarm? = nil
    @State private var detailAlarm: Alarm? = nil
    
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    
    @State private var editMode: EditMode = .inactive
    
    @State private var showingDeleteConfirmation = false
    @State private var itemsToDelete: IndexSet?
    
    var filteredAndSortedAlarms: [Alarm] {
        var filtered = alarmManager.alarms
        return filtered
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack {
                    

                }
                
                List(selection: $editSelection) {
                    ForEach(filteredAndSortedAlarms) { alarm in
                        
                        alarmRow(alarm: alarm)
                            .listRowBackground(Color.black)
                            .contextMenu{
                                Button("Enable/Disable") {
                                    var updated = alarm
                                    updated.isEnabled.toggle()
                                    alarmManager.updateAlarm(alarm: updated)
                                    HapticManager.triggerSelectionHaptic()
                                }
                                Button("Edit") {
                                    selectedAlarm = alarm
                                }
                                Button("Delete", role: .destructive) {
                                    if let index = alarmManager.alarms.firstIndex(where: { $0.id == alarm.id}) {
                                        alarmManager.alarms.remove(at: index)
                                        HapticManager.triggerSelectionHaptic()
                                    }
                                }
                            }
                    }
                    .onDelete(perform: onDelete)
                }
                .environment(\.editMode, $editMode)
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
                .refreshable {
                    HapticManager.triggerSuccessHaptic()
                }
                .navigationTitle("Alarms")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        if editMode == .inactive {
                            EditButton()
                                .foregroundColor(.white)
                        }
                        else {
                            Button("Done") {
                                editMode = .inactive
                            }
                            .foregroundColor(.white)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button("Add New Alarm") {
                                alarmManager.addAlarm()
                                HapticManager.triggerSelectionHaptic()
                            }
                            Button("Settings") {
                                showingSettings = true
                            }
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .foregroundColor(.white)
                        }
                    }
                }
                
                NavigationLink(destination: detailAlarm.map {AlarmDetailView(alarm: $0)}, isActive: Binding(get: {detailAlarm != nil}, set: {if !$0 {detailAlarm = nil}})) {
                    EmptyView()
                }
                .hidden()
            }
            .sheet(item: $selectedAlarm) { alarm in
                EditAlarmView(alarmManager: alarmManager, alarm: alarm)}
            .fullScreenCover(isPresented: $showingSettings) {
                SettingsView(settings: settings, alarmManager: alarmManager)
            }
            .onAppear{
                if alarmManager.alarms.isEmpty {
                    alarmManager.addAlarm()
                }
                if !hasSeenOnboarding {
                    hasSeenOnboarding.toggle()
                    showingOnboarding = true
                }
            }
            /*.fullScreenCover(isPresented: $showingOnboarding){
                OnboardingView(isPresented: $showingOnboarding)
            } */
            .alert(isPresented: $showingDeleteConfirmation) {
                Alert(title: Text("Delete Alarms"), message: Text("Are you sure you want to delete these alarms?"), primaryButton: .destructive(Text("Delete")) {
                    if let offsets = itemsToDelete {
                        alarmManager.deleteAlarm(at: offsets)
                        itemsToDelete = nil
                    }
                }, secondaryButton: .cancel())
            }
        }
        .preferredColorScheme(.dark)
    }
    
    @State private var showingOnboarding = false
    @State private var showingSettings = false
    @State private var editSelection: Set<Alarm.ID> = []
    
    private func onDelete(offsets: IndexSet) {
        itemsToDelete = offsets
        showingDeleteConfirmation = true
    }
    
    private func alarmRow(alarm: Alarm) -> some View {
        Button {
            detailAlarm = alarm
        } label: {
            HStack {
                Circle()
                    .fill(alarm.color)
                    .frame(width: 10, height: 10)
                VStack(alignment: .leading, spacing: 4){
                    Text(formattedTime(alarm.time))
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    HStack {
                        Text(alarm.label)
                            .font(.subheadline)
                            .foregroundStyle(.white)
                        if !alarm.repeatDays.isEmpty {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .foregroundStyle(.white)
                                .font(.subheadline)
                        }
                    }
                }
                Spacer()
                
                Toggle("", isOn: Binding(get: {alarm.isEnabled}, set: {newValue in
                    var updatedAlarm = alarm
                    updatedAlarm.isEnabled = newValue
                    alarmManager.updateAlarm(alarm: updatedAlarm)
                    HapticManager.triggerSelectionHaptic()}))
                .labelsHidden()
                .tint(.green)
            }
        }
        .buttonStyle(.plain)
    }
    
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        if settings.use24HourFormat {
            formatter.dateFormat = "HH:mm"
        }
        return formatter.string(from: date)
    }
}

#Preview {
    ContentView()
}
