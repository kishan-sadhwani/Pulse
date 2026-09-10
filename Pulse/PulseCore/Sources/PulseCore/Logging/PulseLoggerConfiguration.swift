import Foundation

/// Configuration options for `PulseLogger`.
public struct PulseLoggerConfiguration: Sendable, Equatable {
    /// The minimum log level required for a log message to be emitted.
    public var minimumLevel: LogLevel
    
    /// Whether logging is globally enabled.
    public var isEnabled: Bool
    
    /// Whether to include the level emoji symbol in the log prefix.
    public var showEmoji: Bool
    
    /// Whether to include the category name in the log output.
    public var showCategory: Bool
    
    /// Whether to include the timestamp in the log output.
    public var showTimestamp: Bool
    
    /// Whether to include file and line number information for error/fault logs.
    public var showCallerInfo: Bool
    
    /// Explicit redaction override for sensitive metadata.
    /// If `nil`, standard build-time rules (`#if DEBUG false #else true`) apply.
    public var isRedacted: Bool?
    
    /// Creates a new configuration instance with specified settings.
    public init(
        minimumLevel: LogLevel = .debug,
        isEnabled: Bool = true,
        showEmoji: Bool = false,
        showCategory: Bool = true,
        showTimestamp: Bool = false,
        showCallerInfo: Bool = true,
        isRedacted: Bool? = nil
    ) {
        self.minimumLevel = minimumLevel
        self.isEnabled = isEnabled
        self.showEmoji = showEmoji
        self.showCategory = showCategory
        self.showTimestamp = showTimestamp
        self.showCallerInfo = showCallerInfo
        self.isRedacted = isRedacted
    }
}
