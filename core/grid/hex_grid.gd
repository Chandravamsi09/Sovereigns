# Core Engine-Agnostic Hex Grid Storage & Spatial Query Engine
class_name HexGrid
extends RefCounted

var width: int = 0
var height: int = 0
var tiles: Dictionary = {} # Vector2i -> TileData

func _init(p_width: int = 32, p_height: int = 32) -> void:
	width = p_width
	height = p_height
	_initialize_grid()

func _initialize_grid() -> void:
	for r in range(height):
		for q in range(width):
			var coord: HexCoord = HexCoord.new(q, r)
			var tile: TileData = TileData.new(coord, TileData.Biome.PLAINS)
			tiles[coord.to_vector2i()] = tile

func get_tile(coord: HexCoord) -> TileData:
	if coord == null:
		return null
	return tiles.get(coord.to_vector2i(), null)

func has_tile(coord: HexCoord) -> bool:
	if coord == null:
		return false
	return tiles.has(coord.to_vector2i())

func set_tile(coord: HexCoord, tile: TileData) -> void:
	if coord != null and tile != null:
		tiles[coord.to_vector2i()] = tile

func get_tiles_in_range(center: HexCoord, radius: int) -> Array[TileData]:
	var result: Array[TileData] = []
	for q in range(center.q - radius, center.q + radius + 1):
		for r in range(center.r - radius, center.r + radius + 1):
			var candidate: HexCoord = HexCoord.new(q, r)
			if center.distance_to(candidate) <= radius:
				var t: TileData = get_tile(candidate)
				if t != null:
					result.append(t)
	return result

func to_dict() -> Dictionary:
	var tile_array: Array = []
	for key in tiles:
		tile_array.append(tiles[key].to_dict())
	return {
		"width": width,
		"height": height,
		"tiles": tile_array
	}

static func from_dict(dict: Dictionary) -> HexGrid:
	var grid: HexGrid = HexGrid.new(dict.get("width", 32), dict.get("height", 32))
	grid.tiles.clear()
	var tile_array: Array = dict.get("tiles", [])
	for tile_dict in tile_array:
		var tile: TileData = TileData.from_dict(tile_dict)
		grid.set_tile(tile.coord, tile)
	return grid
