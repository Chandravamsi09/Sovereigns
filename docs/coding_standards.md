# Sovereigns Coding & Style Standards

## GDScript Guidelines
- Use explicit type hints for all variables, parameters, and function return values (`var count: int = 0`, `func add(a: int, b: int) -> int:`).
- Class names must be `PascalCase` (`HexGrid`, `TurnManager`).
- File names must be `snake_case` (`hex_grid.gd`, `turn_manager.gd`).
- Member variables: `snake_case` (private/internal prefixed with `_`).
- Constants: `ALL_CAPS_SNAKE_CASE`.
- Prefer static typing and avoid untyped `Variant` dictionary lookups where possible.

## C# Guidelines
- Follow standard C#/.NET naming conventions (`PascalCase` for classes, properties, methods; `camelCase` for local variables and parameters; `_camelCase` for private fields).
- Target .NET 8.0.
- Place all performance-critical AI and pathfinding logic in namespace `Sovereigns.AI` or `Sovereigns.Core.Pathfinding`.

## Testing Rules
- Every file in `/core` must have a corresponding unit test under `/tests/unit/`.
- All GUT test methods must start with `test_` (e.g. `func test_hex_distance_calculation():`).
- Tests must be fully deterministic and headless-safe.
