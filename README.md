# Sovereigns

**Sovereigns** is a production-grade turn-based 4X strategy game (Explore, Expand, Exploit, Exterminate) featuring an optional real-time skirmish battle mode. Built with **Godot 4.3+ (Forward+ Renderer)**, **GDScript** for domain gameplay, and **C#** for high-performance pathfinding and AI evaluation.

---

## 🚀 Current Status: Phase 5 Completed (`v0.5.0-presentation`)

- [x] **Phase 0: Bootstrap**: Project scaffolding, Godot 4.3 configuration, GUT test runner, GitHub Actions CI workflow setup.
- [x] **Phase 1: Core Simulation Engine**: Hexagonal grid coordinate math, biomes/yields tile model, turn manager state machine, resource economy engine, and deterministic JSON save/load engine.
- [x] **Phase 2: Exploration & Expansion**: Procedural map generator (FastNoiseLite), Fog of War vision engine, settlement founding, and cultural territory border manager.
- [x] **Phase 3: Exploitation Engine**: Infrastructure building catalog, Directed Acyclic Graph (DAG) Tech Tree engine, and inter-city Trade Route system.
- [x] **Phase 4: Extermination & Combat Engine**: Unit stats model, turn-based combat resolution, high-performance C# A* pathfinder (`Sovereigns.AI`), and RTS Skirmish Mode arena.
- [x] **Phase 5: Presentation Layer**: RTS/4X Camera Controller, 3D Hex Terrain Renderer, HUD Controller (resource bar, turn counter, action panel), and Main Game Scene wiring.
- [ ] **Phase 6: Next-Gen VFX Pass** (Next)
- [ ] **Phase 7: Strategic AI Opponents**
- [ ] **Phase 8: Polish & Release Candidate**

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
├── ai/             # High-performance C# Pathfinding (HexPathfinder.cs) & Strategic AI
├── vfx/            # Shaders, GPUParticles3D, WorldEnvironment, Volumetric Fog of War
├── tests/          # GUT test suites (unit & integration)
│   └── unit/       # test_hex_grid.gd, test_turn_manager.gd, test_resource_manager.gd, test_save_system.gd,
│                   # test_map_generator.gd, test_fog_of_war.gd, test_city_borders.gd, test_buildings.gd,
│                   # test_tech_tree.gd, test_trade_routes.gd, test_unit_movement.gd, test_combat_resolution.gd,
│                   # test_rts_skirmish.gd, test_presentation_wiring.gd
├── tools/          # Procedural map generator & balance editing tools
└── docs/           # Architecture Decision Records (ADRs) & Game Design Document
```

---

## 🛠️ Running Automated Tests

Headless GUT unit tests run across all core simulation systems & presentation wiring:
```bash
godot --headless -s addons/gut/gut_cmdln.gd -gdir=res://tests/
```

C# AI & Pathfinding NUnit / dotnet tests:
```bash
dotnet test ai/Sovereigns.AI.csproj
```

Test suite files (14 total):
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

---

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
