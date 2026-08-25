# Sovereigns Game Design Document & Architecture Reference

## Overview
**Sovereigns** is a turn-based 4X strategy game featuring hex grid tactical map exploration, settlement founding, technological research DAGs, economic yield optimization, utility AI opponents, and an optional real-time skirmish battle mode built using **Godot 4.3+** and **.NET 8 (C#)**.

## Core Mechanics

### 1. Hex Grid & Coordinates (`/core/grid/`)
- Axial coordinate system `(q, r, s)` with `q + r + s = 0`.
- Biomes: Plains, Grassland, Desert, Tundra, Snow, Ocean, Coast, Mountain.
- Features: Forest, Hills, River, Marsh, Oasis.

### 2. Turn Management & Action Log (`/core/turn/`)
- Phase state machine: `START_TURN`, `ACTION_PHASE`, `END_TURN`, `AI_PROCESSING`.
- Multi-player round robin turn progression.
- Action history logging for deterministic replay and serialization.

### 3. Economy & Yield System (`/core/economy/`, `/core/exploitation/`)
- Treasury Gold, Science, Culture stockpiles and per-turn net yield processing.
- Building catalog (Granary, Library, Forge, Market, Monument) with yield modifiers.
- Tech Tree DAG (Agriculture -> Pottery/Mining -> Writing/Bronze Working -> Mathematics).
- Inter-city Trade Routes with distance-scaled gold and food returns.

### 4. Fog of War & Exploration (`/core/exploration/`)
- Visibility state machine per tile per player: `UNEXPLORED`, `EXPLORED`, `VISIBLE`.
- Dynamic line-of-sight updates around units and cities.

### 5. Combat & RTS Skirmish Arena (`/core/combat/`, `/ai/Pathfinding/`)
- Tactical stats: HP, Attack Power, Defense Power, Attack Range, Movement Points.
- Deterministic combat formula with terrain defense bonuses (Forest/Hills +25%).
- High-performance C# A* pathfinder (`HexPathfinder.cs`).
- Real-time skirmish arena simulator (`RTSSkirmishArena`).

### 6. Presentation Layer & VFX (`/presentation/`, `/vfx/`)
- Forward+ WorldEnvironment with Glow/Bloom, SSAO, SSR.
- Animated water shader and hit-feedback chromatic aberration.
- GPUParticles3D combat impact sparks.
- Smooth RTS Camera with WASD pan, edge scroll, and zoom clamping.
