# M4 - Rich Diagnostics

## Status

Done

## Goal

Improve PulseLogger's diagnostic capabilities by introducing first-class error logging.

## Scope

- Support logging Swift `Error` instances.
- Produce readable error output.
- Include #file, and #line in such error based instances
- Associate errors with existing log levels.
- Preserve all existing public APIs.
- Design the API so execution context can be added in future without breaking changes.

## Out of Scope

- Automatic file/function/line capture.
- Privacy controls.
- Provider-specific formatting.
- Crash reporting.

## Notes

The objective is to make failures significantly more informative while keeping the logging API simple.

Typical usage should evolve towards:

```swift
PulseLogger.error(
    "Failed to fetch profile",
    error: error
)
```

Update the status on top of this file to "Done" and record important architectural decisions once implementation completes.