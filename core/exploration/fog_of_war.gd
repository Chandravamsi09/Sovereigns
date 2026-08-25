# Core Fog of War Engine (Multi-Player Grid Vision Management)
class_name FogOfWar
extends RefCounted

signal vision_updated(player_id: int)

enum Visibility {
	UNEXPLORED,
	EXPLORED,
	VISIBLE
}

var player_id: int = 0
var grid_width: int = 32
var grid_height: int = 32

# Map: Vector2i -> Visibility enum
var visibility_map: Dictionary = {}

func _init(p_player_id: int = 0, p_width: int = 32, p_height: int = 32) -> void:
	player_id = p_player_id
	grid_width = p_width
	grid_height = p_height
	_initialize_map()

func _initialize_map() -> void:
	for r in range(grid_height):
		for q in range(grid_width):
			visibility_map[Vector2i(q, r)] = Visibility.UNEXPLORED

func get_visibility(coord: HexCoord) -> Visibility:
	if coord == null:
		return Visibility.UNEXPLORED
	return visibility_map.get(coord.to_vector2i(), Visibility.UNEXPLORED) as Visibility

func is_visible(coord: HexCoord) -> bool:
	return get_visibility(coord) == Visibility.VISIBLE

func is_explored(coord: HexCoord) -> bool:
	return get_visibility(coord) != Visibility.UNEXPLORED

func begin_turn_vision_update() -> void:
	# Downgrade currently VISIBLE tiles to EXPLORED before re-computing unit vision
	for key in visibility_map:
		if visibility_map[key] == Visibility.VISIBLE:
			visibility_map[key] = Visibility.EXPLORED

func add_vision_source(grid: HexGrid, center: HexCoord, vision_range: int) -> void:
	if grid == null or center == null:
		return
		
	var tiles_in_view: Array[TileData] = grid.get_tiles_in_range(center, vision_range)
	for tile in tiles_in_view:
		visibility_map[tile.coord.to_vector2i()] = Visibility.VISIBLE
		
	vision_updated.emit(player_id)

func to_dict() -> Dictionary:
	var vis_dict: Dictionary = {}
	for k in visibility_map:
		vis_dict["%d,%d" % [k.x, k.y]] = visibility_map[k]
	return {
		"player_id": player_id,
		"width": grid_width,
		"height": grid_height,
		"visibility": vis_dict
	}

static func from_dict(dict: Dictionary) -> FogOfWar:
	var fow: FogOfWar = FogOfWar.new(
		dict.get("player_id", 0),
		dict.get("width", 32),
		dict.get("height", 32)
	)
	var vis_dict: Dictionary = dict.get("visibility", {})
	for key_str in vis_dict:
		var parts: PackedStringArray = key_str.split(",")
		if parts.size() == 2:
			var vec: Vector2i = Vector2i(int(parts[0]), int(parts[1]))
			fow.visibility_map[vec] = vis_dict[key_str] as Visibility
	return fow
