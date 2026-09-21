import Foundation

enum ScriptStore {
    static let directory = URL.documentsDirectory

    static func names() -> [String] {
        seedIfNeeded()
        let files = (try? FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)) ?? []
        return files.filter { $0.pathExtension == "js" }
            .map { $0.deletingPathExtension().lastPathComponent }
            .sorted()
    }

    static func source(named name: String) throws -> String {
        let url = directory.appending(path: name).appendingPathExtension("js")
        guard FileManager.default.fileExists(atPath: url.path) else { throw ScriptError.notFound(name) }
        return try String(contentsOf: url, encoding: .utf8)
    }

    private static func seedIfNeeded() {
        let key = "seededSamples"
        guard !UserDefaults.standard.bool(forKey: key),
              let bundled = Bundle.main.url(forResource: "Scripts", withExtension: nil),
              let files = try? FileManager.default.contentsOfDirectory(at: bundled, includingPropertiesForKeys: nil)
        else { return }
        for file in files where file.pathExtension == "js" {
            let dest = directory.appending(path: file.lastPathComponent)
            if !FileManager.default.fileExists(atPath: dest.path) {
                try? FileManager.default.copyItem(at: file, to: dest)
            }
        }
        UserDefaults.standard.set(true, forKey: key)
    }
}
