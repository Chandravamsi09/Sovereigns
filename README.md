# Sovereigns

**Sovereigns** is a production-grade turn-based 4X strategy game (Explore, Expand, Exploit, Exterminate) featuring an optional real-time skirmish battle mode. Built with **Godot 4.3+ (Forward+ Renderer)**, **GDScript** for domain gameplay, and **C#** for high-performance pathfinding and AI evaluation.

---

## 🚀 Current Status: Phase 7 Completed (`v0.7.0-ai`)

- [x] **Phase 0: Bootstrap**: Project scaffolding, Godot 4.3 configuration, GUT test runner, GitHub Actions CI workflow setup.
- [x] **Phase 1: Core Simulation Engine**: Hexagonal grid coordinate math, biomes/yields tile model, turn manager state machine, resource economy engine, and deterministic JSON save/load engine.
- [x] **Phase 2: Exploration & Expansion**: Procedural map generator (FastNoiseLite), Fog of War vision engine, settlement founding, and cultural territory border manager.
- [x] **Phase 3: Exploitation Engine**: Infrastructure building catalog, Directed Acyclic Graph (DAG) Tech Tree engine, and inter-city Trade Route system.
- [x] **Phase 4: Extermination & Combat Engine**: Unit stats model, turn-based combat resolution, high-performance C# A* pathfinder (`Sovereigns.AI`), and RTS Skirmish Mode arena.
- [x] **Phase 5: Presentation Layer**: RTS/4X Camera Controller, 3D Hex Terrain Renderer, HUD Controller (resource bar, turn counter, action panel), and Main Game Scene wiring.
- [x] **Phase 6: Next-Gen VFX Pass**: WorldEnvironment Forward+ lighting stack (Glow/Bloom, SSAO, SSR), animated water shader, chromatic aberration feedback shader, and GPUParticles3D impact sparks.
- [x] **Phase 7: Strategic AI Opponents**: Utility-based AI decision engine, difficulty tiers (`EASY`, `MEDIUM`, `HARD`), settlement evaluator, tech selection heuristics, and `StrategicAIAgent` controller.
- [ ] **Phase 8: Polish & Release Candidate** (Next)

---

## 🏛️ Project Architecture

```
Sovereigns/
├── core/           # Engine-agnostic 4X simulation logic
│   ├── grid/       # HexCoord, HexGrid, TileData
│   ├── turn/       # TurnManager state machine & action history
│   ├── economy/    # ResourceManager & player treasury
│   ├── map/        # ProceduralMapGen FastNoiseLite world builder
│   ├── exploration/# FogOfWar vision manager
│   ├── expansion/  # City model & BorderManager territory expansion
│   ├── exploitation/# Building catalog, TechTree DAG, TradeRoute system
│   ├── combat/     # Unit stats, CombatResolver, RTSSkirmishArena
│   └── serialization/ # SaveSystem JSON encoder/decoder
├── presentation/   # Godot 3D presentation layer
│   ├── camera/     # RTSCamera controller (pan, zoom, clamp)
│   ├── map/        # HexTerrainRenderer 3D mesh generator
│   ├── ui/         # HUDController resource bar & buttons
│   └── main_game_scene.gd # Main game scene wiring
├── ai/             # Strategic AI Opponents & High-Performance C# Pathfinding
│   ├── Pathfinding/# HexPathfinder.cs (C# A* pathfinder)
│   ├── utility_ai.gd # Score curves & site evaluator
│   └── strategic_ai_agent.gd # Turn execution controller
├── vfx/            # Shaders, GPUParticles3D, WorldEnvironment, Volumetric Fog of War
├── tests/          # GUT test suites (unit & integration)
│   └── unit/       # 16 GUT test suites covering core sim, presentation, VFX, and AI
├── tools/          # Procedural map generator & balance editing tools
└── docs/           # Architecture Decision Records (ADRs) & Game Design Document
```

---

## 🛠️ Running Automated Tests

Headless GUT unit tests run across all core simulation systems, presentation, VFX, and AI:
```bash
godot --headless -s addons/gut/gut_cmdln.gd -gdir=res://tests/
```

C# AI & Pathfinding NUnit / dotnet tests:
```bash
dotnet test ai/Sovereigns.AI.csproj
```

Test suite files (16 total):
- `res://tests/unit/test_hex_grid.gd`
- `res://tests/unit/test_turn_manager.gd`
- `res://tests/unit/test_resource_manager.gd`
- `res://tests/unit/test_save_system.gd`
- `res://tests/unit/test_map_generator.gd`
- `res://tests/unit/test_fog_of_war.gd`
- `res://tests/unit/test_city_borders.gd`
- `res://tests/unit/test_buildings.gd`
- `res://tests/unit/test_tech_tree.gd`
- `res://tests/unit/test_trade_routes.gd`
- `res://tests/unit/test_unit_movement.gd`
- `res://tests/unit/test_combat_resolution.gd`
- `res://tests/unit/test_rts_skirmish.gd`
- `res://tests/unit/test_presentation_wiring.gd`
- `res://tests/unit/test_vfx_stack.gd`
- `res://tests/unit/test_strategic_ai.gd`

---

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
