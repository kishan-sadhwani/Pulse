# M8 - Additional Providers

## Status

Done

## Goal

Expand PulseLogger by implementing additional logging providers using the provider architecture introduced in M7.

## Scope

- Implement an OSLog provider.
- Demonstrate support for multiple providers.
- Allow providers to operate together.

## Out of Scope

- Public API redesign.
- Crash reporting.
- Analytics integration.

## Notes

Adding a new provider should require little more than implementing the provider contract.

Application code should remain unchanged regardless of the active providers.

## Architectural Decisions

- Implemented `OSLogProvider` conforming to `LogProvider` and `Sendable`, integrating `PulseLogger` with Apple's Unified Logging System (`os.Logger`).
- Added `LogLevel.osLogType` mapping internal `LogLevel` entries directly to `OSLogType` (`debug` -> `.debug`, `info` -> `.info`, `warning` -> `.default`, `error` -> `.error`, `fault` -> `.fault`).
- Supported customizable `subsystem` identifiers in `OSLogProvider` with default fallback to `Bundle.main.bundleIdentifier ?? "Pulse"`.
- Enhanced structured metadata serialization in providers with `.withoutEscapingSlashes` to ensure clean URL/path representation in diagnostic JSON logs.
- Verified simultaneous dispatch and thread safety across multiple active providers (`ConsoleLogProvider`, `OSLogProvider`, and custom sinks).