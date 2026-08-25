# GUT Unit Tests for Deterministic Save & Load System
extends "res://addons/gut/test.gd" if FileAccess.file_exists("res://addons/gut/test.gd") else RefCounted

func test_full_game_state_serialization() -> void:
	var grid: HexGrid = HexGrid.new(10, 10)
	var t: TileData = grid.get_tile(HexCoord.new(3, 3))
	t.biome = TileData.Biome.MOUNTAIN
	
	var tm: TurnManager = TurnManager.new([0, 1])
	tm.advance_phase() # ACTION_PHASE
	
	var p0_rm: ResourceManager = ResourceManager.new(0)
	p0_rm.gold = 500
	var p1_rm: ResourceManager = ResourceManager.new(1)
	p1_rm.gold = 300
	
	var resources: Dictionary = {0: p0_rm, 1: p1_rm}
	
	# Serialize
	var json_str: String = SaveSystem.serialize_game_state(grid, tm, resources)
	assert_true(json_str.length() > 0, "Serialized JSON string must not be empty")
	
	# Deserialize
	var restored: Dictionary = SaveSystem.deserialize_game_state(json_str)
	assert_not_null(restored.get("grid"), "Restored grid must not be null")
	assert_not_null(restored.get("turn_manager"), "Restored turn manager must not be null")
	
	var restored_grid: HexGrid = restored["grid"] as HexGrid
	var restored_tm: TurnManager = restored["turn_manager"] as TurnManager
	var restored_res: Dictionary = restored["player_resources"]
	
	assert_eq(restored_grid.get_tile(HexCoord.new(3, 3)).biome, TileData.Biome.MOUNTAIN, "Tile biome must match original")
	assert_eq(restored_tm.current_phase, TurnManager.TurnPhase.ACTION_PHASE, "Turn phase must match original")
	assert_eq((restored_res[0] as ResourceManager).gold, 500, "Player 0 gold must match original")
	assert_eq((restored_res[1] as ResourceManager).gold, 300, "Player 1 gold must match original")
