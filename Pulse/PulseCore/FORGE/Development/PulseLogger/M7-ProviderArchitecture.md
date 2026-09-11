# M7 - Provider Architecture

## Status

Done

## Goal

Refactor PulseLogger to support multiple output providers while preserving the existing public API.

## Scope

- Introduce a provider abstraction.
- Convert the existing console implementation into a provider.
- Support provider registration.
- Preserve all existing logging behavior.

## Out of Scope

- Additional provider implementations.
- Remote logging.
- File logging.

## Notes

This milestone is purely architectural. Existing application code should continue working unchanged.

Typical usage should continue to look identical while internally routing logs through providers.

## Architectural Decisions

- Introduced `LogProvider` protocol (`Sendable`) defining a unified output contract (`log(level:message:category:metadata:error:file:line:)`).
- Created `ConsoleLogProvider` conforming to `LogProvider`, encapsulating formatting logic (emojis, categories, timestamps, caller details, and privacy-filtered metadata JSON) and writing to console stdout.
- Integrated thread-safe provider management in `PulseLogger` via an `os_unfair_lock`-backed store, defaulting to `[ConsoleLogProvider()]`.
- Added provider management APIs: `PulseLogger.register(_:)`, `PulseLogger.setProviders(_:)`, `PulseLogger.unregisterAllProviders()`, `PulseLogger.resetProviders()`, and `PulseLogger.providers`.
- Guaranteed test isolation and clean state resets through `PulseLogger.resetConfiguration()`.