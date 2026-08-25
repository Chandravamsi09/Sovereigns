# GUT Unit Tests for Procedural Map Generator
extends "res://addons/gut/test.gd" if FileAccess.file_exists("res://addons/gut/test.gd") else RefCounted

func test_map_generator_dimensions() -> void:
	var gen: ProceduralMapGen = ProceduralMapGen.new(42)
	var grid: HexGrid = gen.generate_map(16, 16)
	
	assert_eq(grid.width, 16, "Generated grid width must match request")
	assert_eq(grid.height, 16, "Generated grid height must match request")
	assert_not_null(grid.get_tile(HexCoord.new(0, 0)), "Corner tile must exist")

func test_map_generator_determinism() -> void:
	var gen1: ProceduralMapGen = ProceduralMapGen.new(999)
	var grid1: HexGrid = gen1.generate_map(10, 10)
	
	var gen2: ProceduralMapGen = ProceduralMapGen.new(999)
	var grid2: HexGrid = gen2.generate_map(10, 10)
	
	var target_coord: HexCoord = HexCoord.new(4, 4)
	var t1: TileData = grid1.get_tile(target_coord)
	var t2: TileData = grid2.get_tile(target_coord)
	
	assert_eq(t1.biome, t2.biome, "Same seed must yield identical biome")
	assert_eq(t1.feature, t2.feature, "Same seed must yield identical feature")

func test_map_generator_biome_variety() -> void:
	var gen: ProceduralMapGen = ProceduralMapGen.new(12345)
	var grid: HexGrid = gen.generate_map(32, 32)
	
	var biomes_found: Dictionary = {}
	for r in range(grid.height):
		for q in range(grid.width):
			var tile: TileData = grid.get_tile(HexCoord.new(q, r))
			biomes_found[tile.biome] = true
			
	assert_true(biomes_found.size() >= 3, "Procedural map generation must produce at least 3 distinct biomes")
