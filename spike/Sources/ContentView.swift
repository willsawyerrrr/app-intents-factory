import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                Label("Hello World", systemImage: "hand.wave")
            }
            .navigationTitle("Intents Spike")
        }
    }
}
