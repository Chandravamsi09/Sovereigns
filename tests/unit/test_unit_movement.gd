# GUT Unit Tests for Unit Stats & Movement Constraints
extends "res://addons/gut/test.gd" if FileAccess.file_exists("res://addons/gut/test.gd") else RefCounted

func test_unit_initial_stats() -> void:
	var warrior: Unit = Unit.new(1, Unit.UnitType.WARRIOR, 0, HexCoord.new(0, 0))
	assert_eq(warrior.hp, 100, "Warrior HP must be 100")
	assert_eq(warrior.attack_power, 25, "Warrior Attack must be 25")
	assert_eq(warrior.max_movement, 2, "Warrior movement points must be 2")
	
	var cavalry: Unit = Unit.new(2, Unit.UnitType.CAVALRY, 0, HexCoord.new(0, 0))
	assert_eq(cavalry.max_movement, 4, "Cavalry movement points must be 4")

func test_unit_movement_consumption() -> void:
	var u: Unit = Unit.new(1, Unit.UnitType.WARRIOR, 0, HexCoord.new(0, 0))
	assert_true(u.can_move_cost(1), "Unit must be able to move for cost 1")
	u.consume_movement(1)
	assert_eq(u.current_movement, 1, "Remaining movement must be 1")
	
	u.reset_turn_movement()
	assert_eq(u.current_movement, 2, "Movement must reset to max_movement on new turn")
