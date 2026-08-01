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

    public func info(_ message: String) {
        log(level: .info, message: message)
    }

    public func warning(_ message: String) {
        log(level: .warning, message: message)
    }

    public func error(_ message: String) {
        log(level: .error, message: message)
    }

    public func fault(_ message: String) {
        log(level: .fault, message: message)
    }
    
    internal func log(level: LogLevel, message: String) {
        // Output format: [LEVEL] [Category] Message
        let prefix = "[\(level.rawValue.uppercased())]"
        print(" [\(category.name)] \(prefix) \(message)")
    }
}
