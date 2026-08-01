import Foundation

public struct PulseLogger: Sendable {
    public static let shared = PulseLogger()

    public let category: LogCategory

    private init(category: LogCategory = .default) {
        self.category = category
    }
    
    public static func category(_ category: LogCategory) -> PulseLogger {
        return PulseLogger(category: category)
    }

    public func debug(_ message: String) {
        log(level: .debug, message: message)
    }

    public func debug(_ message: String, metadata: [String: String]) {
        log(level: .debug, message: message, metadata: metadata)
    }

    public func info(_ message: String) {
        log(level: .info, message: message)
    }

    public func info(_ message: String, metadata: [String: String]) {
        log(level: .info, message: message, metadata: metadata)
    }

    public func warning(_ message: String) {
        log(level: .warning, message: message)
    }

    public func warning(_ message: String, metadata: [String: String]) {
        log(level: .warning, message: message, metadata: metadata)
    }

    public func error(_ message: String) {
        log(level: .error, message: message)
    }

    public func error(_ message: String, metadata: [String: String]) {
        log(level: .error, message: message, metadata: metadata)
    }

    public func fault(_ message: String) {
        log(level: .fault, message: message)
    }

    public func fault(_ message: String, metadata: [String: String]) {
        log(level: .fault, message: message, metadata: metadata)
    }
    
    internal func log(level: LogLevel, message: String, metadata: [String: String]? = nil) {
        // Output format: [LEVEL] [Category] Message {metadata}
        let prefix = "[\(level.rawValue.uppercased())]"
        var output = "[\(category.name)] \(prefix) \(message)"
        defer {
            print(output)
        }
        
        if let metadata = metadata, !metadata.isEmpty {
            guard let data = try? JSONSerialization.data(withJSONObject: metadata, options: [.prettyPrinted]),
                  let metaString = String(data: data, encoding: .utf8)
            else {
                return
            }
            output += "\n\(metaString)"
        }
        
    }
}
