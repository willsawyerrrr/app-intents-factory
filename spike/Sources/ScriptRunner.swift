import Foundation
import JavaScriptCore
import UIKit

enum ScriptError: LocalizedError {
    case notFound(String)
    case noMain
    case failed(String)

    var errorDescription: String? {
        switch self {
        case .notFound(let name): "No script named \(name)."
        case .noMain: "Script must define `main(input)`."
        case .failed(let message): message
        }
    }
}

struct ScriptResult: Sendable {
    var output: String
    var logs: [String]
}

enum ScriptRunner {
    static func run(name: String, input: String?) async throws -> ScriptResult {
        let source = try ScriptStore.source(named: name)
        return try await Task.detached { try execute(source: source, input: input) }.value
    }

    private final class Logs {
        var lines: [String] = []
    }

    private static func execute(source: String, input: String?) throws -> ScriptResult {
        let logs = Logs()
        let context = JSContext()!
        var failure: String?
        context.exceptionHandler = { _, exception in failure = exception?.toString() }
        install(in: context, logs: logs)

        context.evaluateScript(source)
        if let failure { throw ScriptError.failed(failure) }
        guard let main = context.objectForKeyedSubscript("main"), main.isObject else { throw ScriptError.noMain }

        let value = main.call(withArguments: [input as Any? ?? NSNull()])
        if let failure { throw ScriptError.failed(failure) }
        return ScriptResult(output: stringify(value, in: context), logs: logs.lines)
    }

    private static func stringify(_ value: JSValue?, in context: JSContext) -> String {
        guard let value, !value.isUndefined, !value.isNull else { return "" }
        if value.isString { return value.toString() }
        let json = context.objectForKeyedSubscript("JSON")?.invokeMethod("stringify", withArguments: [value])
        return json?.isString == true ? json!.toString() : value.toString()
    }

    private static func install(in context: JSContext, logs: Logs) {
        func bind(_ name: String, _ block: AnyObject) {
            context.setObject(block, forKeyedSubscript: name as NSString)
        }

        let log: @convention(block) (String) -> Void = { logs.lines.append($0) }
        let sleep: @convention(block) (Double) -> Void = { Thread.sleep(forTimeInterval: $0 / 1000) }
        let get: @convention(block) (String) -> String? = { urlString in
            do {
                return try httpGet(urlString)
            } catch {
                JSContext.current()?.exception = JSValue(newErrorFromMessage: error.localizedDescription, in: JSContext.current())
                return nil
            }
        }
        let read: @convention(block) () -> String = { UIPasteboard.general.string ?? "" }
        let write: @convention(block) (String) -> Void = { UIPasteboard.general.string = $0 }

        bind("__log", log as AnyObject)
        bind("sleep", sleep as AnyObject)
        bind("__httpGet", get as AnyObject)
        bind("__clipRead", read as AnyObject)
        bind("__clipWrite", write as AnyObject)

        context.evaluateScript("""
        var console = { log: function () { __log(Array.prototype.map.call(arguments, String).join(" ")); } };
        var http = { get: __httpGet };
        var clipboard = { read: __clipRead, write: __clipWrite };
        """)
    }

    private final class Box: @unchecked Sendable {
        var result: Result<String, Error> = .failure(URLError(.unknown))
    }

    private static func httpGet(_ urlString: String) throws -> String {
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        let semaphore = DispatchSemaphore(value: 0)
        let box = Box()
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                box.result = .failure(error)
            } else {
                box.result = .success(String(decoding: data ?? Data(), as: UTF8.self))
            }
            semaphore.signal()
        }.resume()
        semaphore.wait()
        return try box.result.get()
    }
}
