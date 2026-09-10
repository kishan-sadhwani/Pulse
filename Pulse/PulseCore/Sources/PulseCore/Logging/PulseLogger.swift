import Foundation

private final class ConfigurationStore: @unchecked Sendable {
    private var lock = os_unfair_lock_s()
    private var _configuration: PulseLoggerConfiguration = PulseLoggerConfiguration()
    
    var configuration: PulseLoggerConfiguration {
        get {
            os_unfair_lock_lock(&lock)
            defer { os_unfair_lock_unlock(&lock) }
            return _configuration
        }
        set {
            os_unfair_lock_lock(&lock)
            defer { os_unfair_lock_unlock(&lock) }
            _configuration = newValue
        }
    }
    
    func update(_ mutate: (inout PulseLoggerConfiguration) -> Void) {
        os_unfair_lock_lock(&lock)
        defer { os_unfair_lock_unlock(&lock) }
        mutate(&_configuration)
    }
    
    func reset() {
        os_unfair_lock_lock(&lock)
        defer { os_unfair_lock_unlock(&lock) }
        _configuration = PulseLoggerConfiguration()
    }
}

private let configStore = ConfigurationStore()

public struct PulseLogger: Sendable {
    public static let shared = PulseLogger()

    public let category: LogCategory

    /// The current active configuration for `PulseLogger`.
    public static var configuration: PulseLoggerConfiguration {
        get { configStore.configuration }
    }

    /// Mutates the centralized runtime configuration for `PulseLogger`.
    public static func configure(_ mutate: (inout PulseLoggerConfiguration) -> Void) {
        configStore.update(mutate)
    }

    /// Sets the centralized configuration for `PulseLogger`.
    public static func configure(with configuration: PulseLoggerConfiguration) {
        configStore.configuration = configuration
    }

    /// Resets the configuration back to default settings.
    public static func resetConfiguration() {
        configStore.reset()
    }

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
    
    @discardableResult
    internal func log(
        level: LogLevel,
        message: String,
        metadata: [String: LogMetadataValue]? = nil,
        error: Swift.Error? = nil,
        file: String? = nil,
        line: UInt? = nil
    ) -> String? {
        let config = PulseLogger.configuration
        
        guard config.isEnabled else {
            return nil
        }
        
        guard level >= config.minimumLevel else {
            return nil
        }
        
        var output = ""
        
        if config.showTimestamp {
            let timestamp = ISO8601DateFormatter().string(from: Date())
            output += "[\(timestamp)] "
        }
        
        if config.showCategory {
            output += "[\(category.name)] "
        }
        
        if config.showEmoji {
            output += "[\(level.rawValue.uppercased()) \(level.symbol)]"
        } else {
            output += "[\(level.rawValue.uppercased())]"
        }
        
        output += " \(message)"
        
        if config.showCallerInfo, let file = file, let line = line {
            let filename = (file as NSString).lastPathComponent
            output += " [\(filename):\(line)]"
        }
        
        if let error = error {
            output += " | Error: \(error)"
        }
        
        if let metadata = metadata, !metadata.isEmpty {
            let isRedacted: Bool
            if let configRedacted = config.isRedacted {
                isRedacted = configRedacted
            } else {
                #if DEBUG
                isRedacted = false
                #else
                isRedacted = true
                #endif
            }
            
            let rawMetadata = metadata.mapValues { $0.rendered(redacted: isRedacted) }
            if let data = try? JSONSerialization.data(withJSONObject: rawMetadata, options: [.prettyPrinted, .sortedKeys]),
               let metaString = String(data: data, encoding: .utf8) {
                output += "\n\(metaString)"
            }
        }
        
        print(output)
        return output
    }
}

