import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                Label("Fetch Page Title", systemImage: "safari")
                Label("Create Text File", systemImage: "doc.text")
            }
            .navigationTitle("Intents Spike")
        }
    }
}
