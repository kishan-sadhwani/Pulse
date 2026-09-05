---
schema: forge/v1

name: Pulse

scope: project

default_load:
  - ${workspaceFolder}/FORGE/Vision.md
  - ${workspaceFolder}/FORGE/Principles.md

children: 
  - ${workspaceFolder}/Pulse/PulseCore/

knowledge:
  architecture:
    - ${workspaceFolder}/FORGE/Architecture/SystemOverview.md
    - ${workspaceFolder}/FORGE/Architecture/DomainArchitecture.md
---

# FORGE Routing Manifest

## Purpose
The FORGE routing manifest is the single, deterministic entry point for humans and AI agents to discover and load the minimal required FORGE context for any boundary (project, package, feature, or task).

## Context Hierarchy
- **Project → Package → Feature → Task** – Knowledge is organized from the broadest scope (the whole project) down to the smallest work unit. Each level inherits the context of its parent.

## Default Loading Rules
- **Default load `Vision.md` and `Principles.md`** as the foundational layer unless a more specific document explicitly supersedes them.
- For a given query, load only the target document and any directly referenced principles, following the hierarchy (task → feature → package → project).

## Document Map & Roles
| Document | Scope | Responsibility |
|---|---|---|
| `Vision.md` | Why Pulse and FORGE exist; high‑level inspiration. | Provides the overarching motivation and philosophical backdrop. |
| `Principles.md` | Core timeless engineering principles. | Defines the decision‑making framework that guides all downstream work. |
| `Architecture/SystemOverview.md` | High‑level system architecture. | Describes the major components and their interactions without implementation details. |
| `Architecture/DomainArchitecture.md` | Domain architecture. | Describes the domain architecture. |

*Only files that currently exist are listed. New documents should be added here when created.*

## Ownership & Responsibility Boundaries
- Each document owns its defined scope; content that belongs elsewhere should be referenced, not duplicated.
- Updates must stay within the document’s responsibility area to prevent overlap.

## When to Create a New FORGE Document
- Create a new file when a concept cannot be expressed within an existing document’s scope **and** it represents a reusable knowledge unit (e.g., a new architectural pattern, a tooling guideline, or a domain‑specific rule).
- Otherwise, extend the appropriate existing document.

## Future Package‑Level Routers
- Packages may contain their own `FORGE/ROUTER.md` (e.g., `Packages/PulseCore/FORGE/ROUTER.md`).
- The root router remains the first stop; it points to package routers for deeper, package‑specific context.
- AI navigation: start at the root router, then follow the package router to locate feature‑ or task‑level documents, loading only what is needed at each step.


*The routing manifest ensures deterministic, minimal‑context traversal for AI while remaining clear and maintainable for humans.*
