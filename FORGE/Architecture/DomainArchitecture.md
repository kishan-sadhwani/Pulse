# Domain Architecture

## Purpose
This document defines the normative domain architecture for the Pulse host application. **Future AI agents must treat this as the authoritative architectural contract and reject changes that violate these rules unless this document is intentionally updated.**

Pulse is not the product; it is a showcase application demonstrating the capabilities, architecture, and usage of reusable Pulse packages (starting with PulseCore). The host application remains intentionally thin and disposable. All reusable capability and business logic must reside within packages whenever practical.

The architecture optimizes for clarity, maintainability, modularity, testability, and deterministic AI reasoning, prioritizing these over complex architectural patterns.

---

## Architectural Pillars

### 1. UI Framework: SwiftUI
**Decision:** SwiftUI is the exclusive UI framework.
**Justification:** SwiftUI provides a declarative, state-driven approach that is native, concise, and highly readable. It significantly reduces boilerplate code, aligning with our goal of simplicity and easing AI comprehension.
**Exclusions:** UIKit (unless bridging is strictly required for unsupported features).

### 2. Presentation Pattern: Strict MVVM
**Decision:** Model-View-ViewModel (MVVM) is the standard presentation pattern.
**Ownership Chain:** `Coordinator` → `ViewModel` → `Services/Packages` → `State` → `View`.
**Responsibilities:**
- **View:** Purely declarative UI. It observes state from the ViewModel and delegates all user actions back to the ViewModel. Views do not hold complex logic or perform formatting.
- **ViewModel:** Manages the presentation state and UI logic. It interacts with dependencies (injected via init), orchestrates data, and exposes observable presentation state for the View to observe. It has no knowledge of SwiftUI Views.
**Justification:** Strict separation of UI and presentation logic makes code highly testable, predictable, and easy for AI to modify in isolation.
**Exclusions:** TCA (The Composable Architecture), Redux, VIPER. These patterns introduce excessive boilerplate, complex global state management, or rigid structures that violate our goal of simplicity and minimal cognitive load.

### 3. Navigation: Coordinator Pattern
**Decision:** Navigation is extracted out of Views and managed by Coordinators.
**Responsibilities:** Coordinators own ViewModel lifecycle, feature composition, routing logic, dependency instantiation, and screen transitions. Views only notify their delegates (often the Coordinator) of navigation intents.
**Justification:** SwiftUI's native navigation often tightly couples views together. Coordinators decouple screens, ensuring Views remain independent and reusable, which simplifies the dependency graph and testing.

### 4. Dependency Management: Constructor Injection
**Decision:** Constructor dependency injection is the only permitted method for resolving dependencies.
**Responsibilities:** All ViewModels, Services, and Coordinators must declare their dependencies explicitly in their initializers (ideally as protocols).
**Justification:** Constructor injection makes the dependency graph compile-time safe, explicit, and easy to mock in tests. It creates a predictable dependency tree that AI agents can easily trace.
**Exclusions:** DI Frameworks (Swinject, Factory) and Service Locators. These obfuscate the dependency graph behind runtime resolution, making it harder for both humans and AI to statically reason about dependencies.

### 5. Async Model: Swift Concurrency
**Decision:** Swift Concurrency (`async`/`await`, `Task`, `actor`) is the default asynchronous model.
**Justification:** Native concurrency provides safe, readable, and compiler-checked asynchronous code. It eliminates callback hell and simplifies error handling.
**Exclusions:** Combine (except for observable presentation state observation in MVVM) and RxSwift. Third-party reactive frameworks add steep learning curves and cognitive overhead that run counter to our simplicity principle.

### 6. State Management: Local State Ownership
**Decision:** State must be kept local to the feature (within its ViewModel).
**Justification:** Avoiding global state prevents unintended side-effects and tight coupling across the application. Data should flow predictably.
**Exclusions:** Global stores (like Redux or environment-heavy setups). Global state should be avoided unless strictly justified by a cross-cutting concern (e.g., global authentication state).

---

## Modularity & Organization

### 1. Feature-First Organization
**Decision:** The application is organized by features, not by technical layers.
**Structure:** Group files by their functional domain (e.g., `Authentication/`, `Profile/`). Inside a feature folder, you will find its specific Views, ViewModels, and related models.
**Justification:** Feature-based organization keeps related code collocated. An engineer (or AI) working on a feature only needs to load the context of that specific directory, dramatically reducing cognitive load.
**Exclusions:** Do not use layer-based folders like `Views/`, `ViewModels/`, `Models/` at the root level.

### 2. Canonical Feature Contract
**Decision:** Every feature must adhere to a consistent internal structure and ownership model.
**Contract:**
- **Coordinator:** Owns routing, feature composition, and ViewModel lifecycle.
- **ViewModel:** Manages observable presentation state and presentation logic.
- **View:** Purely declarative UI, observing the ViewModel.
- **Models (Optional):** Feature-specific data representations.
- **Services (Optional):** App-specific logic that cannot be pushed down to a generic package.

### 3. Package Interaction Boundaries
**Decision:** The host application must strictly consume public APIs from Pulse packages.
**Rules:**
- Views and ViewModels must never bypass public APIs to access internal package logic.
- Business logic is pushed down into packages; the app is merely a consumer and presentation layer.
- Packages are conceptually "black boxes" to the host application.

### 4. Composition Root
**Decision:** A centralized Composition Root (typically at the App/Scene level or a root Coordinator) is responsible for assembling the object graph.
**Justification:** It keeps dependency instantiation out of feature code, ensuring that components remain decoupled and solely focused on their responsibilities.

---

## Architectural Invariants
*These rules must be preserved by all future contributors and AI agents.*

1. **No Business Logic in Views:** If a View calculates, formats, or makes a network request, it is an error.
2. **No UI Frameworks in ViewModels:** ViewModels must not `import SwiftUI` (unless specifically for observable presentation state wrappers if unavoidable) or reference UI components.
3. **Explicit Dependencies:** No singletons or shared instances accessed implicitly. Everything must be injected.
4. **Thin Host App:** If logic can be isolated, tested, and reused without UI, it belongs in a Package, not the host application.
5. **No Hidden State:** Data flow must be traceable through initializers and public interfaces.
6. **No Circular Dependencies:** Circular dependencies between layers, features, or packages are strictly prohibited.
7. **Package Dependency Invariant:** Packages must never depend on the host application, features, or the presentation layer. Dependencies must exclusively point downward toward lower architectural layers.

## Rules for Introducing New Packages/Features
1. **Define the Boundary:** Before creating a feature, determine if it represents app-specific presentation (Host App) or domain logic (Package).
2. **Draft the Public API:** Design the interfaces the package will expose before writing implementation.
3. **Update Documentation:** If a new architectural pattern is introduced (e.g., local storage strategy), this document must be intentionally updated first.

## Architecture Evolution
Architecture is expected to evolve only through intentional, documented decisions justified by maintainability, modularity, testability, or AI reasoning.
