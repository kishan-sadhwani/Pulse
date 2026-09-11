import Foundation

/// A protocol that defines an output destination provider for `PulseLogger`.
///
/// Implement this protocol to create custom log sinks such as file loggers,
/// remote monitoring providers, or OSLog bridges.
public protocol LogProvider: Sendable {
    /// Logs a message and associated diagnostic information.
    ///
    /// - Parameters:
    ///   - level: The severity level of the log.
    ///   - message: The primary log message.
    ///   - category: The category associated with the logger.
    ///   - metadata: Optional key-value metadata attached to the log.
    ///   - error: Optional Swift `Error` associated with the log.
    ///   - file: The file path where the log was emitted.
    ///   - line: The line number where the log was emitted.
    func log(
        level: LogLevel,
        message: String,
        category: LogCategory,
        metadata: [String: LogMetadataValue]?,
        error: (any Swift.Error)?,
        file: String?,
        line: UInt?
    )
}
