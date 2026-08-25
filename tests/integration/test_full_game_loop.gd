# GUT Multi-Turn Full Game Loop Integration Test Suite
extends "res://addons/gut/test.gd" if FileAccess.file_exists("res://addons/gut/test.gd") else RefCounted

func test_full_20_turn_gameplay_simulation() -> void:
	# 1. Initialize Map and Systems
	var map_gen: ProceduralMapGen = ProceduralMapGen.new(2026)
	var grid: HexGrid = map_gen.generate_map(24, 24)
	var turn_mgr: TurnManager = TurnManager.new([0, 1])
	
	var p0_res: ResourceManager = ResourceManager.new(0)
	var p1_res: ResourceManager = ResourceManager.new(1)
	var resources: Dictionary = {0: p0_res, 1: p1_res}
	
	var p0_tech: TechTree = TechTree.new(0)
	var p1_tech: TechTree = TechTree.new(1)
	
	var ai: StrategicAIAgent = StrategicAIAgent.new(1, UtilityAI.DifficultyTier.MEDIUM)
	
	# Initial Player Actions
	p0_tech.set_current_research("agriculture")
	var city_p0: City = City.new(1, "Capital Alpha", 0, HexCoord.new(5, 5))
	var border_mgr: BorderManager = BorderManager.new()
	border_mgr.register_city(city_p0, grid)
	
	# 2. Run 20 Turn Simulation Loop
	for turn in range(1, 21):
		# Player 0 Turn
		p0_res.process_turn_yields()
		p0_tech.add_science_points(p0_res.science_per_turn)
		city_p0.process_turn(grid)
		turn_mgr.advance_phase()
		
		# Player 1 (AI) Turn
		p1_res.process_turn_yields()
		p1_tech.add_science_points(p1_res.science_per_turn)
		ai.execute_turn(grid, p1_tech, p1_res)
		turn_mgr.end_current_player_turn()
		
	# 3. Assertions after 20 turns
	assert_eq(turn_mgr.current_turn, 21, "Turn counter must reach 21 after completing 20 full rounds")
	assert_true(p0_res.gold > 100, "Player 0 gold treasury must have accumulated over 20 turns")
	assert_true(p0_tech.is_unlocked("agriculture"), "Player 0 must have unlocked Agriculture science")
	assert_true(p1_tech.current_research_tech_id != "" or p1_tech.unlocked_techs.size() > 0, "AI must have researched technology")
	
	# 4. Save and Load Roundtrip Audit
	var json_save: String = SaveSystem.serialize_game_state(grid, turn_mgr, resources)
	var restored_state: Dictionary = SaveSystem.deserialize_game_state(json_save)
	
	var restored_tm: TurnManager = restored_state.get("turn_manager") as TurnManager
	assert_eq(restored_tm.current_turn, 21, "Saved & restored turn number must equal 21")
