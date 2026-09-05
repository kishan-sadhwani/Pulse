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

    public func debug(_ message: String, metadata: [String: LogMetadataValue]? = nil) {
        log(level: .debug, message: message, metadata: metadata)
    }

    public func info(_ message: String, metadata: [String: LogMetadataValue]? = nil) {
        log(level: .info, message: message, metadata: metadata)
    }

    public func warning(_ message: String, metadata: [String: LogMetadataValue]? = nil) {
        log(level: .warning, message: message, metadata: metadata)
    }

    public func error(_ message: String, metadata: [String: LogMetadataValue]? = nil, error: Swift.Error? = nil, file: String = #file, line: UInt = #line) {
        log(level: .error, message: message, metadata: metadata, error: error, file: file, line: line)
    }

    public func fault(_ message: String, metadata: [String: LogMetadataValue]? = nil, error: Swift.Error? = nil, file: String = #file, line: UInt = #line) {
        log(level: .fault, message: message, metadata: metadata, error: error, file: file, line: line)
    }
    
    internal func log(level: LogLevel, message: String, metadata: [String: LogMetadataValue]? = nil, error: Swift.Error? = nil, file: String? = nil, line: UInt? = nil) {
        // Output format: [LEVEL] [Category] Message {metadata}
        let prefix = "[\(level.rawValue.uppercased())]"
        var output = "[\(category.name)] \(prefix) \(message)"
        
        if let file = file, let line = line {
            let filename = (file as NSString).lastPathComponent
            output += " [\(filename):\(line)]"
        }
        
        if let error = error {
            output += " | Error: \(error)"
        }
        
        defer {
            print(output)
        }
        
        if let metadata = metadata, !metadata.isEmpty {
            #if DEBUG
            let isRedacted = false
            #else
            let isRedacted = true
            #endif
            
            let rawMetadata = metadata.mapValues { $0.rendered(redacted: isRedacted) }
            guard let data = try? JSONSerialization.data(withJSONObject: rawMetadata, options: [.prettyPrinted, .sortedKeys]),
                  let metaString = String(data: data, encoding: .utf8)
            else {
                return
            }
            output += "\n\(metaString)"
        }
        
    }
}
