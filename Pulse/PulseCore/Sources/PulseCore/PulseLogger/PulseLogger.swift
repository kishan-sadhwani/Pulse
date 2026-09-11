import Foundation

private final class LogEngineStore: @unchecked Sendable {
    private var lock = os_unfair_lock_s()
    private var _configuration: PulseLoggerConfiguration = PulseLoggerConfiguration()
    private var _providers: [any LogProvider] = [ConsoleLogProvider()]

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

    var providers: [any LogProvider] {
        get {
            os_unfair_lock_lock(&lock)
            defer { os_unfair_lock_unlock(&lock) }
            return _providers
        }
        set {
            os_unfair_lock_lock(&lock)
            defer { os_unfair_lock_unlock(&lock) }
            _providers = newValue
        }
    }

    func updateConfiguration(_ mutate: (inout PulseLoggerConfiguration) -> Void) {
        os_unfair_lock_lock(&lock)
        defer { os_unfair_lock_unlock(&lock) }
        mutate(&_configuration)
    }

    func register(provider: any LogProvider) {
        os_unfair_lock_lock(&lock)
        defer { os_unfair_lock_unlock(&lock) }
        _providers.append(provider)
    }

    func unregisterAllProviders() {
        os_unfair_lock_lock(&lock)
        defer { os_unfair_lock_unlock(&lock) }
        _providers.removeAll()
    }

    func resetProviders() {
        os_unfair_lock_lock(&lock)
        defer { os_unfair_lock_unlock(&lock) }
        _providers = [ConsoleLogProvider()]
    }

    func reset() {
        os_unfair_lock_lock(&lock)
        defer { os_unfair_lock_unlock(&lock) }
        _configuration = PulseLoggerConfiguration()
        _providers = [ConsoleLogProvider()]
    }
}

private let engineStore = LogEngineStore()

/// A lightweight, thread-safe, high-performance diagnostic logging engine for the Pulse ecosystem.
///
/// `PulseLogger` provides:
/// - Severity filtering via `LogLevel` (`debug`, `info`, `warning`, `error`, `fault`)
/// - Domain categorization via `LogCategory`
/// - Pluggable provider architecture (`LogProvider`, `ConsoleLogProvider`, `OSLogProvider`)
/// - Lazy autoclosure evaluation for zero overhead on filtered messages
/// - Built-in privacy controls for sensitive metadata
/// - Thread-safe configuration and provider dispatch
public struct PulseLogger: Sendable {
    /// The default shared instance configured with `.default` category.
    public static let shared = PulseLogger()

    /// The category associated with this logger instance.
    public let category: LogCategory

    /// The current active configuration for `PulseLogger`.
    public static var configuration: PulseLoggerConfiguration {
        get { engineStore.configuration }
    }

    /// Mutates the centralized runtime configuration for `PulseLogger`.
    ///
    /// - Parameter mutate: A closure receiving an `inout` reference to the active configuration.
    public static func configure(_ mutate: (inout PulseLoggerConfiguration) -> Void) {
        engineStore.updateConfiguration(mutate)
    }

    /// Sets the centralized configuration for `PulseLogger`.
    ///
    /// - Parameter configuration: The new configuration to apply.
    public static func configure(with configuration: PulseLoggerConfiguration) {
        engineStore.configuration = configuration
    }

    /// Resets configuration and providers back to default settings.
    public static func resetConfiguration() {
        engineStore.reset()
    }

    // MARK: - Provider Management

    /// The list of currently active log providers.
    public static var providers: [any LogProvider] {
        get { engineStore.providers }
    }

    /// Registers an additional log provider to receive log events.
    ///
    /// - Parameter provider: The provider conforming to `LogProvider`.
    public static func register(_ provider: any LogProvider) {
        engineStore.register(provider: provider)
    }

    /// Registers an additional log provider to receive log events.
    ///
    /// - Parameter provider: The provider conforming to `LogProvider`.
    public static func register(provider: any LogProvider) {
        engineStore.register(provider: provider)
    }

    /// Sets the list of active log providers, replacing any existing ones.
    ///
    /// - Parameter providers: The new array of log providers.
    public static func setProviders(_ providers: [any LogProvider]) {
        engineStore.providers = providers
    }

    /// Unregisters all active log providers.
    public static func unregisterAllProviders() {
        engineStore.unregisterAllProviders()
    }

    /// Resets the registered providers to the default provider set (`[ConsoleLogProvider()]`).
    public static func resetProviders() {
        engineStore.resetProviders()
    }

    // MARK: - Initialization

    private init(category: LogCategory = .default) {
        self.category = category
    }

    /// Creates a logger scoped to a specific `LogCategory`.
    ///
    /// - Parameter category: The category to assign to this logger.
    /// - Returns: A configured `PulseLogger` instance.
    public static func category(_ category: LogCategory) -> PulseLogger {
        return PulseLogger(category: category)
    }

    // MARK: - Logging APIs

    /// Logs a debug-level message.
    ///
    /// The message is lazily evaluated only if debug logging is enabled.
    ///
    /// - Parameters:
    ///   - message: The message autoclosure to log.
    ///   - metadata: Optional key-value metadata.
    public func debug(_ message: @autoclosure () -> String, metadata: [String: LogMetadataValue]? = nil) {
        log(level: .debug, message: message(), metadata: metadata)
    }

    /// Logs an info-level message.
    ///
    /// The message is lazily evaluated only if info logging is enabled.
    ///
    /// - Parameters:
    ///   - message: The message autoclosure to log.
    ///   - metadata: Optional key-value metadata.
    public func info(_ message: @autoclosure () -> String, metadata: [String: LogMetadataValue]? = nil) {
        log(level: .info, message: message(), metadata: metadata)
    }

    /// Logs a warning-level message.
    ///
    /// The message is lazily evaluated only if warning logging is enabled.
    ///
    /// - Parameters:
    ///   - message: The message autoclosure to log.
    ///   - metadata: Optional key-value metadata.
    public func warning(_ message: @autoclosure () -> String, metadata: [String: LogMetadataValue]? = nil) {
        log(level: .warning, message: message(), metadata: metadata)
    }

    /// Logs an error-level message with optional `Error` details and automatic source caller capture.
    ///
    /// The message is lazily evaluated only if error logging is enabled.
    ///
    /// - Parameters:
    ///   - message: The message autoclosure to log.
    ///   - metadata: Optional key-value metadata.
    ///   - error: Optional Swift `Error` to log.
    ///   - file: The source file path where the log was emitted (captured automatically).
    ///   - line: The source file line where the log was emitted (captured automatically).
    public func error(
        _ message: @autoclosure () -> String,
        metadata: [String: LogMetadataValue]? = nil,
        error: Swift.Error? = nil,
        file: String = #file,
        line: UInt = #line
    ) {
        log(level: .error, message: message(), metadata: metadata, error: error, file: file, line: line)
    }

    /// Logs a critical fault-level message with optional `Error` details and automatic source caller capture.
    ///
    /// The message is lazily evaluated only if fault logging is enabled.
    ///
    /// - Parameters:
    ///   - message: The message autoclosure to log.
    ///   - metadata: Optional key-value metadata.
    ///   - error: Optional Swift `Error` to log.
    ///   - file: The source file path where the log was emitted (captured automatically).
    ///   - line: The source file line where the log was emitted (captured automatically).
    public func fault(
        _ message: @autoclosure () -> String,
        metadata: [String: LogMetadataValue]? = nil,
        error: Swift.Error? = nil,
        file: String = #file,
        line: UInt = #line
    ) {
        log(level: .fault, message: message(), metadata: metadata, error: error, file: file, line: line)
    }

    /// Core logging routine that evaluates thresholds and dispatches to all registered providers.
    ///
    /// - Parameters:
    ///   - level: The severity level.
    ///   - message: The message autoclosure.
    ///   - metadata: Optional key-value metadata.
    ///   - error: Optional Swift `Error`.
    ///   - file: Optional caller source file.
    ///   - line: Optional caller source line.
    /// - Returns: A formatted string representation of the log entry if emitted, or `nil` if filtered out.
    @discardableResult
    internal func log(
        level: LogLevel,
        message: @autoclosure () -> String,
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

        let evaluatedMessage = message()
        let activeProviders = PulseLogger.providers
        for provider in activeProviders {
            provider.log(
                level: level,
                message: evaluatedMessage,
                category: category,
                metadata: metadata,
                error: error,
                file: file,
                line: line
            )
        }

        return ConsoleLogProvider().format(
            level: level,
            message: evaluatedMessage,
            category: category,
            metadata: metadata,
            error: error,
            file: file,
            line: line,
            configuration: config
        )
    }
}
