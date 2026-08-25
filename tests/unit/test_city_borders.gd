# GUT Unit Tests for City Founding & Territory Border Expansion
extends "res://addons/gut/test.gd" if FileAccess.file_exists("res://addons/gut/test.gd") else RefCounted

func test_city_founding_and_initial_borders() -> void:
	var grid: HexGrid = HexGrid.new(10, 10)
	var city_loc: HexCoord = HexCoord.new(5, 5)
	var city: City = City.new(1, "Solaria", 0, city_loc)
	
	var bm: BorderManager = BorderManager.new()
	bm.register_city(city, grid)
	
	assert_true(city.claimed_tiles.size() > 1, "City must claim initial ring of tiles on registration")
	var center_tile: TileData = grid.get_tile(city_loc)
	assert_eq(center_tile.owner_player_id, 0, "City center tile owner must be Player 0")
	assert_eq(center_tile.city_id, 1, "City center tile city ID must be 1")

func test_city_growth_and_production() -> void:
	var grid: HexGrid = HexGrid.new(10, 10)
	var city: City = City.new(1, "Solaria", 0, HexCoord.new(5, 5))
	city.set_production("Warrior", 10)
	
	# Simulate turns
	city.process_turn(grid)
	assert_true(city.stored_production > 0, "City production must advance each turn")
	
	# Force completion
	city.stored_production = 10
	city.process_turn(grid)
	assert_eq(city.current_production_item, "", "Production queue must clear upon item completion")

func test_cultural_border_expansion() -> void:
	var grid: HexGrid = HexGrid.new(10, 10)
	var city: City = City.new(1, "Solaria", 0, HexCoord.new(5, 5))
	var bm: BorderManager = BorderManager.new()
	bm.register_city(city, grid)
	
	var initial_count: int = city.claimed_tiles.size()
	var expanded: bool = bm.expand_border_cultural(city, grid)
	
	assert_true(expanded, "Border expansion must return true when unclaimed neighbor tiles exist")
	assert_eq(city.claimed_tiles.size(), initial_count + 1, "Claimed tile count must increase by 1")
