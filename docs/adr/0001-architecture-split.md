# ADR 0001: Strict Engine-Agnostic Architecture Split

## Status
Accepted

## Context
A 4X strategy game requires extensive logic for hex grids, turn management, resource calculations, combat resolution, tech tree dependency graphs, and deterministic save/load states. Coupling gameplay logic directly to Godot `Node` scene graphs hinders automated unit testing, headless server simulation, and fast iteration. Furthermore, performance-heavy components like pathfinding and utility AI score evaluation benefit from C# runtime optimization.

## Decision
We establish a strict architectural boundary dividing the codebase into four primary tiers:

1. **/core** (Pure GDScript / Data Models)
   - Contains pure simulation logic with zero dependency on Godot `Node`, `CanvasItem`, or `Node3D`.
   - Classes inherit from `RefCounted` or `Object`.
   - 100% unit-testable in isolation without scene tree instantiation.

2. **/presentation** (Godot Scenes & Rendering)
   - Contains Godot `Node3D`, `Control`, `SubViewport`, and UI components.
   - Observes `/core` state changes and emits user interactions back to `/core` action queues.

3. **/ai** (C# / GDScript Performance Layer)
   - C# implementations for A* pathfinding and strategic utility evaluation.
   - Interoperates cleanly with GDScript via Godot C# bindings.

4. **/vfx** (Visual Effects Engine)
   - Shaders, `GPUParticles3D`, `WorldEnvironment` configuration, and post-processing filters.

## Consequences
- Clean separation allows headless testing in CI pipelines.
- AI evaluation and pathfinding run smoothly without blocking the main render loop.
- Modders or alternate renderers can re-use `/core` without UI coupling.
