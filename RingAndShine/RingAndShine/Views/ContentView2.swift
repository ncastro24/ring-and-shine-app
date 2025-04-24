//
//  ContentView2.swift
//  RingAndShine
//
//  Created by Nayeli Castro on 4/20/25.
//

import SwiftUI

struct ContentView2: View {
    @StateObject private var alarmManager = AlarmManager()
    @StateObject private var settings = Settings()
    
    @State private var selectedAlarm: Alarm? = nil
    @State private var detailAlarm: Alarm? = nil
    
    @State private var searchText: String = ""
    
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    
    @State private var editMode: EditMode = .inactive
    
    @State private var showingDeleteConfirmation = false
    @State private var itemsToDelete: IndexSet?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack {

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
                /*if alarmManager.alarms.isEmpty {
                    alarmManager.addAlarm()
                }*/
                if !hasSeenOnboarding {
                    hasSeenOnboarding.toggle()
                    showingOnboarding = true
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    @State private var showingOnboarding = false
    @State private var showingSettings = false
    @State private var editSelection: Set<Alarm.ID> = []
}

#Preview {
    ContentView2()
}
