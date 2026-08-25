# GUT Unit Tests for Fog of War Vision System
extends "res://addons/gut/test.gd" if FileAccess.file_exists("res://addons/gut/test.gd") else RefCounted

func test_fog_of_war_initial_unexplored() -> void:
	var fow: FogOfWar = FogOfWar.new(0, 10, 10)
	var coord: HexCoord = HexCoord.new(5, 5)
	
	assert_eq(fow.get_visibility(coord), FogOfWar.Visibility.UNEXPLORED, "Initial tile visibility must be UNEXPLORED")
	assert_false(fow.is_visible(coord), "Tile must not be visible initially")
	assert_false(fow.is_explored(coord), "Tile must not be explored initially")

func test_fog_of_war_vision_source() -> void:
	var fow: FogOfWar = FogOfWar.new(0, 10, 10)
	var grid: HexGrid = HexGrid.new(10, 10)
	var center: HexCoord = HexCoord.new(5, 5)
	
	fow.add_vision_source(grid, center, 2)
	assert_true(fow.is_visible(center), "Center tile must be VISIBLE after adding vision source")
	assert_true(fow.is_explored(center), "Center tile must be EXPLORED")
	
	var neighbor: HexCoord = HexCoord.new(6, 5)
	assert_true(fow.is_visible(neighbor), "Neighbor tile within radius 2 must be VISIBLE")

func test_fog_of_war_turn_transition() -> void:
	var fow: FogOfWar = FogOfWar.new(0, 10, 10)
	var grid: HexGrid = HexGrid.new(10, 10)
	var center: HexCoord = HexCoord.new(5, 5)
	
	fow.add_vision_source(grid, center, 1)
	assert_true(fow.is_visible(center), "Tile must be VISIBLE before turn transition")
	
	fow.begin_turn_vision_update()
	assert_eq(fow.get_visibility(center), FogOfWar.Visibility.EXPLORED, "Tile must transition to EXPLORED after turn vision reset")
	assert_false(fow.is_visible(center), "Tile is no longer actively VISIBLE until vision source re-applied")
	assert_true(fow.is_explored(center), "Tile remains EXPLORED")
