# M5 - Sensitive Data Handling

## Status

Completed

## Goal

Introduce data classification to PulseLogger, allowing logging providers to make environment-aware decisions about exposing or redacting sensitive information without changing the logging API.

## Scope

- Introduce public and private data classification.
- Preserve the original value internally.
- Expose data classification to logging providers.
- Demonstrate environment-aware rendering (e.g. visible during development, redacted in production).
- Preserve all existing public logging APIs.

## Out of Scope

- Logger configuration.
- Additional providers.
- Encryption or secure storage.
- Compliance or auditing features.

## Notes

This milestone introduces **classification**, not redaction.

The logger should classify data as public or private while leaving the final rendering decision to the active logging provider.

Typical usage should evolve towards:

```swift
PulseLogger.info(
    "User signed in",
    metadata: [
        "email": .private(email),
        "userId": .public(id)
    ]
)
```

The same log may appear differently depending on the active provider or environment.

For example:

- Development Console → Show private values.
- Production Console → Redact private values.
- Remote Provider → Apply provider-specific privacy policy.

## Architectural Decisions

- Introduced `LogMetadataValue` enum which conforms to `ExpressibleByStringLiteral`. This allows `[String: LogMetadataValue]` to accept `["key": "value"]` for backward compatibility, automatically wrapping them as `.public`.
- Redaction evaluation uses `rendered(redacted:)` on `LogMetadataValue`, leaving the responsibility to the logger (or provider) on whether to pass `true` or `false` based on the environment (e.g., `#if DEBUG`).