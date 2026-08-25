# Sovereigns

**Sovereigns** is a production-grade turn-based 4X strategy game (Explore, Expand, Exploit, Exterminate) featuring an optional real-time skirmish battle mode. Built with **Godot 4.3+ (Forward+ Renderer)**, **GDScript** for domain gameplay, and **C#** for high-performance pathfinding and AI evaluation.

---

## 🏛️ Project Architecture

```
Sovereigns/
├── core/           # Engine-agnostic 4X simulation logic (Hex grid, economy, combat, tech tree, turn manager)
├── presentation/   # Godot 3D presentation layer (Camera controller, 3D hex terrain, unit scenes, HUD/UI)
├── ai/             # High-performance C# / GDScript strategic opponent AI & pathfinding
├── vfx/            # Shaders, GPUParticles3D, WorldEnvironment, Volumetric Fog of War
├── tests/          # GUT (Godot Unit Test) runner & NUnit test suites
├── tools/          # Procedural map generator & balance editing tools
└── docs/           # Architecture Decision Records (ADRs) & Game Design Document
```

---

## 🛠️ Requirements & Setup

- **Godot Engine**: 4.3+ (with .NET / C# support)
- **.NET SDK**: 8.0+

### Running Automated Tests
Headless GUT unit tests:
```bash
godot --headless -s addons/gut/gut_cmdln.gd -gdir=res://tests/
```

### Running C# AI Tests
```bash
dotnet test ai/
```

---

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
