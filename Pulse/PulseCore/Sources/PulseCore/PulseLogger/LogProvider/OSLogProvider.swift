import Foundation
import OSLog

/// A log provider that routes logs to Apple's Unified Logging System (`OSLog`).
public struct OSLogProvider: LogProvider, Sendable {
    /// The subsystem identifier used when dispatching logs to `OSLog`.
    public let subsystem: String

    /// Creates an `OSLogProvider` with a specified subsystem.
    ///
    /// - Parameter subsystem: The subsystem identifier. Defaults to the main bundle identifier,
    ///   or `"Pulse"` if the bundle identifier is not available.
    public init(subsystem: String = Bundle.main.bundleIdentifier ?? "Pulse") {
        self.subsystem = subsystem
    }

    /// Logs an entry to Apple's Unified Logging system.
    ///
    /// - Parameters:
    ///   - level: The severity level of the log.
    ///   - message: The primary log message.
    ///   - category: The category associated with the logger.
    ///   - metadata: Optional key-value metadata attached to the log.
    ///   - error: Optional Swift `Error` associated with the log.
    ///   - file: The file path where the log was emitted.
    ///   - line: The line number where the log was emitted.
    public func log(
        level: LogLevel,
        message: String,
        category: LogCategory,
        metadata: [String: LogMetadataValue]?,
        error: (any Swift.Error)?,
        file: String?,
        line: UInt?
    ) {
        let config = PulseLogger.configuration
        let formattedMessage = format(
            level: level,
            message: message,
            category: category,
            metadata: metadata,
            error: error,
            file: file,
            line: line,
            configuration: config
        )

        let logger = os.Logger(subsystem: subsystem, category: category.name)
        logger.log(level: level.osLogType, "\(formattedMessage, privacy: .public)")
    }

    /// Formats a log entry into a string representation for OSLog output.
    ///
    /// - Parameters:
    ///   - level: The severity level of the log.
    ///   - message: The primary log message.
    ///   - category: The category associated with the logger.
    ///   - metadata: Optional key-value metadata attached to the log.
    ///   - error: Optional Swift `Error` associated with the log.
    ///   - file: The file path where the log was emitted.
    ///   - line: The line number where the log was emitted.
    ///   - config: The configuration governing formatting rules.
    /// - Returns: A fully formatted log string.
    public func format(
        level: LogLevel,
        message: String,
        category: LogCategory,
        metadata: [String: LogMetadataValue]?,
        error: (any Swift.Error)?,
        file: String?,
        line: UInt?,
        configuration config: PulseLoggerConfiguration
    ) -> String {
        var output = ""

        if config.showTimestamp {
            let timestamp = Date().ISO8601Format()
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
            if let data = try? JSONSerialization.data(withJSONObject: rawMetadata, options: [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]),
               let metaString = String(data: data, encoding: .utf8) {
                output += "\n\(metaString)"
            }
        }

        return output
    }
}

extension LogLevel {
    /// Maps the `PulseLogger` severity level to Apple Unified Logging's `OSLogType`.
    public var osLogType: OSLogType {
        switch self {
        case .debug:
            return .debug
        case .info:
            return .info
        case .warning:
            return .default
        case .error:
            return .error
        case .fault:
            return .fault
        }
    }
}
