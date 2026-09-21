import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var scripts: [String] = []
    @State private var selected: String?
    @State private var input = ""
    @State private var output = ""
    @State private var logs: [String] = []
    @State private var running = false

    var body: some View {
        NavigationStack {
            List {
                Section("Scripts") {
                    ForEach(scripts, id: \.self) { name in
                        Button {
                            selected = name
                        } label: {
                            HStack {
                                Text(name)
                                Spacer()
                                if selected == name { Image(systemName: "checkmark") }
                            }
                        }
                    }
                }
                Section("Run") {
                    TextField("Input", text: $input)
                    Button(running ? "Running…" : "Run") { run() }
                        .disabled(selected == nil || running)
                }
                if !output.isEmpty {
                    Section("Output") { Text(output).textSelection(.enabled) }
                }
                if !logs.isEmpty {
                    Section("Console") { ForEach(logs.indices, id: \.self) { Text(logs[$0]).font(.footnote.monospaced()) } }
                }
            }
            .navigationTitle("Intents Spike")
            .refreshable { scripts = ScriptStore.names() }
        }
        .onAppear { scripts = ScriptStore.names() }
        .onChange(of: scenePhase) { if scenePhase == .active { scripts = ScriptStore.names() } }
    }

    private func run() {
        guard let name = selected else { return }
        running = true
        Task {
            defer { running = false }
            do {
                let result = try await ScriptRunner.run(name: name, input: input.isEmpty ? nil : input)
                output = result.output
                logs = result.logs
            } catch {
                output = "Error: \(error.localizedDescription)"
                logs = []
            }
        }
    }
}
