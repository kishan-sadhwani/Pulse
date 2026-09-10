import Foundation

/// Centralized configuration options for `PulseLogger`.
///
/// Use `PulseLogger.configure` to customize runtime behavior such as minimum log levels,
/// formatting options (emojis, categories, caller details, timestamps), and privacy redaction.
public struct PulseLoggerConfiguration: Sendable, Equatable {
    /// The minimum log level required for a log message to be emitted.
    /// Messages with severity below this threshold are ignored.
    public var minimumLevel: LogLevel
    
    /// Whether logging is globally enabled. When `false`, all logging calls are discarded.
    public var isEnabled: Bool
    
    /// Whether to include the level emoji symbol in formatted log output (e.g. `[INFO 🔵]`).
    public var showEmoji: Bool
    
    /// Whether to include the category name in formatted log output (e.g. `[Network]`).
    public var showCategory: Bool
    
    /// Whether to include an ISO8601 timestamp in formatted log output (e.g. `[2026-09-10T16:00:00Z]`).
    public var showTimestamp: Bool
    
    /// Whether to include file and line number information for error and fault logs (e.g. `[NetworkClient.swift:120]`).
    public var showCallerInfo: Bool
    
    /// Explicit redaction override for sensitive metadata.
    ///
    /// If `nil`, standard build-time rules apply (`false` in DEBUG builds, `true` in release builds).
    /// If set to `true` or `false`, overrides the default behavior unconditionally.
    public var isRedacted: Bool?
    
    /// Creates a new configuration instance with specified settings.
    ///
    /// - Parameters:
    ///   - minimumLevel: The minimum log level to emit. Defaults to `.debug`.
    ///   - isEnabled: Whether logging is enabled. Defaults to `true`.
    ///   - showEmoji: Whether to show emoji icons in level prefixes. Defaults to `false`.
    ///   - showCategory: Whether to include the category name. Defaults to `true`.
    ///   - showTimestamp: Whether to include ISO8601 timestamps. Defaults to `false`.
    ///   - showCallerInfo: Whether to include caller file and line info for errors. Defaults to `true`.
    ///   - isRedacted: Optional explicit override for metadata redaction. Defaults to `nil`.
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
