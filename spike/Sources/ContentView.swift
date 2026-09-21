import EventKit
import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var remindersStatus = EKEventStore.authorizationStatus(for: .reminder)

    var body: some View {
        NavigationStack {
            List {
                Section("Intents") {
                    Label("Create Reminder", systemImage: "checklist")
                    Label("Fetch Page Title", systemImage: "safari")
                    Label("Create Text File", systemImage: "doc.text")
                }
                Section("Permissions") {
                    if remindersStatus == .fullAccess {
                        Label("Reminders granted", systemImage: "checkmark")
                    } else {
                        Button("Grant Reminders Access") {
                            Task {
                                _ = try? await EKEventStore().requestFullAccessToReminders()
                                remindersStatus = EKEventStore.authorizationStatus(for: .reminder)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Intents Spike")
        }
        .onChange(of: scenePhase) {
            guard scenePhase == .active else { return }
            remindersStatus = EKEventStore.authorizationStatus(for: .reminder)
            SpikeShortcuts.updateAppShortcutParameters()
        }
    }
}
