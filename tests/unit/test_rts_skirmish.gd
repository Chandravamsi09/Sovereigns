# GUT Unit Tests for RTS Skirmish Arena
extends "res://addons/gut/test.gd" if FileAccess.file_exists("res://addons/gut/test.gd") else RefCounted

func test_rts_skirmish_arena_resolution() -> void:
	var army_a: Array[Unit] = [
		Unit.new(1, Unit.UnitType.WARRIOR, 0, HexCoord.new(0, 0)),
		Unit.new(2, Unit.UnitType.WARRIOR, 0, HexCoord.new(0, 0))
	]
	var army_b: Array[Unit] = [
		Unit.new(3, Unit.UnitType.WARRIOR, 1, HexCoord.new(0, 0))
	]
	
	var arena: RTSSkirmishArena = RTSSkirmishArena.new(army_a, army_b, 0, 1)
	var winner: int = arena.run_full_skirmish(20)
	
	assert_true(winner == 0 or winner == 1, "Skirmish winner must be either Player 0 or Player 1")
	assert_true(arena.is_finished, "Skirmish arena must complete")
