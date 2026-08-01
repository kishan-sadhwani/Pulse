---
schema: mdad/v1

scope: package

entrypoint: false

default_load:
  - ${workspaceFolder}/Pulse/PulseCore/MDAD/Vision.md
  - ${workspaceFolder}/Pulse/PulseCore/MDAD/Principles.md

knowledge:
  architecture:
    - ${workspaceFolder}/Pulse/PulseCore/MDAD/Architecture/SystemOverview.md
    - ${workspaceFolder}/Pulse/PulseCore/MDAD/Architecture/DomainArchitecture.md

  features:
    PulseLogger:
      milestones: ${workspaceFolder}/Pulse/PulseCore/MDAD/Development/PulseLogger/
---
# MDAD Routing Manifest

## Purpose

This router is the canonical entry point for the PulseCore engineering boundary.
Its responsibility is to direct AI agents to the minimum required project knowledge before implementation.
The router does not contain engineering knowledge itself. It only tells an AI where that knowledge resides.

# Routing Rules

For every engineering request:
1. Load every document listed under `default_load`.
2. Resolve additional knowledge using the `knowledge` section.
3. Load only the documentation required for the requested task.
4. Prefer deterministic routing over repository-wide semantic search.
5. Begin source code analysis only after documentation and milestone context has been established.

# Source Code Rules

After documentation has been loaded:
- Restrict source analysis to the implementation directories specified by the routed feature whenever practical.
- Avoid unnecessary repository exploration.
- Load additional source files only when required by discovered dependencies.

# Notes

This router intentionally contains no project-specific engineering decisions.
Its only responsibility is deterministic navigation to project knowledge.
