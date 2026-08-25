# Core Territory Border Manager & Expansion Engine
class_name BorderManager
extends RefCounted

signal border_expanded(city_id: int, new_tile: HexCoord)

var cities: Dictionary = {} # city_id -> City

func register_city(city: City, grid: HexGrid) -> void:
	if city == null:
		return
	cities[city.city_id] = city
	
	# Initial border claim: radius 1 ring around city center
	if grid != null:
		var ring: Array[TileData] = grid.get_tiles_in_range(city.location, 1)
		for tile in ring:
			if tile.owner_player_id == -1 or tile.owner_player_id == city.owner_player_id:
				tile.owner_player_id = city.owner_player_id
				tile.city_id = city.city_id
				if not _has_coord(city.claimed_tiles, tile.coord):
					city.claimed_tiles.append(tile.coord)

func expand_border_cultural(city: City, grid: HexGrid) -> bool:
	if city == null or grid == null:
		return false
		
	# Find unclaimed adjacent tiles around current city borders
	var candidate_tiles: Array[TileData] = []
	for claimed_coord in city.claimed_tiles:
		var tile: TileData = grid.get_tile(claimed_coord)
		if tile != null:
			for n_coord in claimed_coord.get_neighbors():
				var candidate: TileData = grid.get_tile(n_coord)
				if candidate != null and candidate.owner_player_id == -1:
					if not candidate_tiles.has(candidate):
						candidate_tiles.append(candidate)
						
	if candidate_tiles.is_empty():
		return false
		
	# Pick best candidate (e.g. highest total yields)
	var best_candidate: TileData = candidate_tiles[0]
	var best_score: int = -1
	for c in candidate_tiles:
		var y: Dictionary = c.get_total_yields()
		var score: int = y.get("food", 0) * 2 + y.get("production", 0) * 2 + y.get("gold", 0)
		if score > best_score:
			best_score = score
			best_candidate = c
			
	best_candidate.owner_player_id = city.owner_player_id
	best_candidate.city_id = city.city_id
	city.claimed_tiles.append(best_candidate.coord)
	
	border_expanded.emit(city.city_id, best_candidate.coord)
	return true

func _has_coord(list: Array[HexCoord], target: HexCoord) -> bool:
	for c in list:
		if c.is_equal(target):
			return true
	return false
