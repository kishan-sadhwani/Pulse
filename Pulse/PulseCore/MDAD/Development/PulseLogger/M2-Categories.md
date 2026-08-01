# M2 - Categories

## Status

**IMPLEMENTATION COMPLETED, DO NOT IMPLEMENT AGAIN**

## Goal

Introduce log categorization to provide contextual logging while preserving the simplicity and API stability established in M1.

## Scope

- Introduce a `LogCategory` model.
- Define a small set of default categories.
- Support category-aware log formatting.
- Introduce scoped logger instances.
- Preserve all M1 logging APIs.

## Out of Scope

- Structured metadata.
- Error/context logging.
- Privacy controls.
- Logger configuration.
- Multiple providers.
- File or remote logging.
- Custom user-defined categories (unless implementation naturally supports them).

## Notes

Categories should improve readability and reduce repetitive code at the call site.
The preferred usage should naturally evolve towards:

```swift
let logger = PulseLogger.category(.network)

logger.debug("Starting request")
logger.info("Request completed")
```

Implementation should remain lightweight and avoid introducing abstractions intended for future milestones.