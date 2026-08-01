# M3 - Structured Metadata

## Status

Done

## Goal

Allow logs to carry structured contextual information alongside the primary log message.

## Touches

Sources/PulseCore/Logging

## Scope

- Introduce structured metadata.
- Support key-value metadata.
- Render metadata consistently.
- Keep metadata optional.
- Preserve all existing public APIs.

## Out of Scope

- Error logging.
- Privacy controls.
- Configuration.
- Multiple providers.
- Custom formatting.

## Notes

Metadata should improve diagnostics without reducing readability. Prefer a lightweight API that scales naturally with future milestones.

Update the status and capture any important architectural decisions once implementation completes.