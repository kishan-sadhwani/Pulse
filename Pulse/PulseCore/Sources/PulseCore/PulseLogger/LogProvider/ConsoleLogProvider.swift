import Foundation

/// A log provider that formats and outputs log entries to standard console output (`print`).
public struct ConsoleLogProvider: LogProvider, Sendable {
    /// Creates a new `ConsoleLogProvider`.
    public init() {}

    /// Formats and logs the entry to standard console output.
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
        print(formattedMessage)
    }

    /// Formats a log entry into a string according to the supplied configuration.
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
