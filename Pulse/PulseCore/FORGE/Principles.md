# PulseCore Principles

In addition to the root Pulse principles, PulseCore adheres to the following:

### UI Independence
PulseCore must never depend on UI frameworks (such as SwiftUI or UIKit). It defines the core domain and business logic, independent of presentation.

### Pure Domain Logic
Keep business logic pure and deterministic where possible. Side effects should be carefully managed, isolated, and abstracted behind protocols.

### High Testability
Because it houses the core rules of the application, PulseCore must maintain the highest standard of automated test coverage. Tests serve as the canonical documentation for the domain rules.
