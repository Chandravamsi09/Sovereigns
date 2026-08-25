# Core Engine-Agnostic Hex Coordinate System (Axial/Cube Coordinates)
class_name HexCoord
extends RefCounted

var q: int = 0 # Column
var r: int = 0 # Row
var s: int = 0 # Component (q + r + s = 0)

const DIRECTIONS: Array[Vector2i] = [
	Vector2i(1, 0),   # East
	Vector2i(1, -1),  # North-East
	Vector2i(0, -1),  # North-West
	Vector2i(-1, 0),  # West
	Vector2i(-1, 1),  # South-West
	Vector2i(0, 1)    # South-East
]

func _init(p_q: int = 0, p_r: int = 0) -> void:
	q = p_q
	r = p_r
	s = -p_q - p_r

static func from_cube(p_q: int, p_r: int, p_s: int) -> HexCoord:
	assert(p_q + p_r + p_s == 0, "Cube coordinate sum q + r + s must equal 0")
	return HexCoord.new(p_q, p_r)

func to_vector2i() -> Vector2i:
	return Vector2i(q, r)

func add(other: HexCoord) -> HexCoord:
	return HexCoord.new(q + other.q, r + other.r)

func subtract(other: HexCoord) -> HexCoord:
	return HexCoord.new(q - other.q, r - other.r)

func distance_to(other: HexCoord) -> int:
	var dq: int = absi(q - other.q)
	var dr: int = absi(r - other.r)
	var ds: int = absi(s - other.s)
	return (dq + dr + ds) / 2

func get_neighbors() -> Array[HexCoord]:
	var neighbors: Array[HexCoord] = []
	for dir in DIRECTIONS:
		neighbors.append(HexCoord.new(q + dir.x, r + dir.y))
	return neighbors

func is_equal(other: HexCoord) -> bool:
	if other == null:
		return false
	return q == other.q and r == other.r

func to_dict() -> Dictionary:
	return {"q": q, "r": r}

static func from_dict(dict: Dictionary) -> HexCoord:
	return HexCoord.new(dict.get("q", 0), dict.get("r", 0))

func _to_string() -> String:
	return "HexCoord(%d, %d, %d)" % [q, r, s]
