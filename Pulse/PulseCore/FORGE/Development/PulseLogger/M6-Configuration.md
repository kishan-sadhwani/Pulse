# M6 - Configuration

## Status

Done

## Goal

Allow PulseLogger behavior to be configured without changing its public logging API.

## Scope

- Configure minimum log level.
- Enable or disable logging.
- Configure formatting behavior.
- Support centralized runtime configuration.

## Out of Scope

- Multiple providers.
- Remote logging.
- File logging.

## Notes

Configuration should influence logger behavior, never how developers use the logger.

Typical usage should evolve towards:

```swift
PulseLogger.configure {
    $0.minimumLevel = .warning
}
```

## Architectural Decisions

- Introduced `PulseLoggerConfiguration` as a `Sendable` value type defining runtime behavior (minimum level, enablement toggle, format options for emoji/category/timestamp/caller info, and explicit redaction override).
- Conformed `LogLevel` to `Comparable` to allow clean level comparisons (`level >= config.minimumLevel`).
- Implemented synchronized global configuration storage via an `os_unfair_lock`-backed container ensuring thread safety and Swift 6 concurrency compliance without unnecessary actor hops.
- Added `PulseLogger.configure(_:)`, `PulseLogger.configure(with:)`, and `PulseLogger.resetConfiguration()` for declarative runtime modification.