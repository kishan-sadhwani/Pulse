---
schema: mdad/v1
scope: package
entrypoint: false
default_load:
  - ${workspaceFolder}/PulseCore/MDAD/Vision.md
  - ${workspaceFolder}/PulseCore/MDAD/Principles.md
children: []
routes:
  architecture:
    - ${workspaceFolder}/PulseCore/MDAD/Architecture/SystemOverview.md
    - ${workspaceFolder}/PulseCore/MDAD/Architecture/DomainArchitecture.md
---

# PulseCore MDAD Routing Manifest

## Purpose
This routing manifest is the deterministic entry point for context related specifically to the `PulseCore` package. It inherits and extends the project-level context from the root router.

## Document Map & Roles
| Document | Scope | Responsibility |
|---|---|---|
| `Vision.md` | Why PulseCore exists. | Provides the motivation for isolating core logic into this package. |
| `Principles.md` | Core package-level principles. | Defines rules such as UI independence and domain purity. |
| `Architecture/SystemOverview.md` | High-level package architecture. | Describes the internal components of PulseCore. |
| `Architecture/DomainArchitecture.md` | Domain architecture. | Describes the domain architecture inside the package. |
