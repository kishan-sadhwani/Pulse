# PulseCore Domain Architecture

## Purpose
This document defines the normative architectural contract for the `PulseCore` package. **Future AI agents must treat this as the authoritative architectural contract and reject changes that violate these rules unless this document is intentionally updated.**

PulseCore is a reusable foundation package, not an application. It contains only domain-agnostic reusable infrastructure.

---

## Architectural Pillars

### 1. Package Responsibility
**Decision:** PulseCore is the foundational layer.
**Rules:** It must only contain domain-agnostic reusable infrastructure (e.g., logging, feature flags, environment, configuration).
**Exclusions:** It must exclude all application-level concerns, including UI frameworks (SwiftUI/UIKit), presentation patterns (MVVM), navigation, coordinators, and the application's composition root.

### 2. Dependency Direction
**Decision:** Dependencies flow strictly downward.
**Rules:** PulseCore must have absolutely zero dependencies on the host `Pulse` application or any higher-level feature packages. It sits at the bottom of the dependency graph.

### 3. Public API Philosophy & Visibility Rules
**Decision:** Default to `internal` visibility with an API-first approach.
**Rules:** Every new capability must begin with an intentionally designed public API before its internal implementation. Types, properties, and methods must be `internal` or `private` by default. `public` visibility is exclusively reserved for the deliberate, minimal surface area exposed to consumer packages.

### 4. Feature Isolation & Package Organization
**Decision:** Internal modularity via functional grouping.
**Rules:** Code must be organized by functional capability (e.g., `Logging/`, `Environment/`) rather than by technical layer. Each functional area should follow a canonical internal structure: **Public API → Internal Implementation → Tests**, while keeping the internal implementation details flexible and strictly isolated.

### 5. Concurrency Policy
**Decision:** Granular Swift Concurrency.
**Rules:** Utilize Swift Concurrency (`async`/`await`, `Task`) efficiently. Avoid blanket actor isolation (e.g., arbitrarily wrapping entire layers in `@MainActor` or custom global actors) unless strictly necessary for state protection. Favor stateless, non-isolated structures where possible to maximize performance and reusability.

### 6. Extension Policy
**Decision:** Evolution through reusability.
**Rules:** PulseCore evolves *only* through the addition of reusable infrastructure. App-specific logic or one-off features must be pushed up to the host application or a specialized higher-level package.

---

## Architectural Invariants
*These rules must be preserved by all future contributors and AI agents.*

1. **No UI Dependencies:** `import SwiftUI` or `import UIKit` are strictly prohibited.
2. **Downward Dependencies Only:** PulseCore cannot import or reference anything from the host application or higher-level features.
3. **Internal by Default:** Never use `public` unless explicitly intending to expose the API.
4. **No Presentation Logic:** MVVM, routing, and Coordinators are application concerns and do not belong here.
5. **Agnostic Infrastructure:** Capabilities must be generic infrastructure reusable across different features or applications.
6. **Intentional API Changes:** Any changes to the public API must be deliberate and version-aware.
