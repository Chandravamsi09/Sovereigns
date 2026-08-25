# GUT Unit Tests for Turn Manager
extends "res://addons/gut/test.gd" if FileAccess.file_exists("res://addons/gut/test.gd") else RefCounted

func test_turn_initialization() -> void:
	var tm: TurnManager = TurnManager.new([0, 1])
	assert_eq(tm.current_turn, 1, "Game must start on turn 1")
	assert_eq(tm.get_active_player_id(), 0, "Player 0 must be initial active player")
	assert_eq(tm.current_phase, TurnManager.TurnPhase.START_TURN, "Phase must start at START_TURN")

func test_turn_advancement() -> void:
	var tm: TurnManager = TurnManager.new([0, 1])
	tm.advance_phase()
	assert_eq(tm.current_phase, TurnManager.TurnPhase.ACTION_PHASE, "Phase must advance to ACTION_PHASE")
	
	tm.end_current_player_turn()
	assert_eq(tm.get_active_player_id(), 1, "Active player must switch to Player 1")
	assert_eq(tm.current_turn, 1, "Turn number remains 1 until all players finish")
	
	tm.end_current_player_turn()
	assert_eq(tm.get_active_player_id(), 0, "Active player must wrap around to Player 0")
	assert_eq(tm.current_turn, 2, "Turn number must increment to 2 after all players complete round")

func test_action_logging_and_serialization() -> void:
	var tm: TurnManager = TurnManager.new([0, 1])
	tm.log_action("MOVE_UNIT", {"from": [0,0], "to": [1,0]})
	assert_eq(tm.action_history.size(), 1, "Action log must contain 1 action")
	
	var serialized: Dictionary = tm.to_dict()
	var restored: TurnManager = TurnManager.from_dict(serialized)
	assert_eq(restored.current_turn, 1, "Restored turn must be 1")
	assert_eq(restored.action_history.size(), 1, "Restored action history size must match")
