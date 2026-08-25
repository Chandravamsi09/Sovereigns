# GUT Unit Tests for Hex Grid & Coordinates
extends "res://addons/gut/test.gd" if FileAccess.file_exists("res://addons/gut/test.gd") else RefCounted

func test_hex_coord_distance() -> void:
	var c1: HexCoord = HexCoord.new(0, 0)
	var c2: HexCoord = HexCoord.new(3, -1) # distance = 3
	assert_eq(c1.distance_to(c2), 3, "Distance between (0,0) and (3,-1) must be 3")

func test_hex_coord_neighbors() -> void:
	var center: HexCoord = HexCoord.new(2, 2)
	var neighbors: Array[HexCoord] = center.get_neighbors()
	assert_eq(neighbors.size(), 6, "A hex cell must have exactly 6 neighbors")
	
	for n in neighbors:
		assert_eq(center.distance_to(n), 1, "Distance to direct neighbor must be 1")

func test_hex_grid_creation_and_range() -> void:
	var grid: HexGrid = HexGrid.new(10, 10)
	var center: HexCoord = HexCoord.new(5, 5)
	
	var tile: TileData = grid.get_tile(center)
	assert_not_null(tile, "Center tile must exist")
	
	var in_range: Array[TileData] = grid.get_tiles_in_range(center, 2)
	# Radius 2 ring contains 1 + 6 + 12 = 19 tiles max
	assert_true(in_range.size() > 0, "Tiles in range 2 must return non-empty array")
	for t in in_range:
		assert_true(center.distance_to(t.coord) <= 2, "Tile in range must have distance <= 2")

func test_hex_grid_serialization() -> void:
	var grid: HexGrid = HexGrid.new(5, 5)
	var center: HexCoord = HexCoord.new(2, 2)
	var t: TileData = grid.get_tile(center)
	t.biome = TileData.Biome.DESERT
	t.set_feature(TileData.Feature.OASIS)
	t.owner_player_id = 1
	
	var serialized: Dictionary = grid.to_dict()
	var restored: HexGrid = HexGrid.from_dict(serialized)
	
	var restored_t: TileData = restored.get_tile(center)
	assert_not_null(restored_t, "Restored tile must not be null")
	assert_eq(restored_t.biome, TileData.Biome.DESERT, "Restored biome must be DESERT")
	assert_eq(restored_t.owner_player_id, 1, "Restored owner must be 1")
