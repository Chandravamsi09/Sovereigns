# GUT Unit Tests for Turn-Based Combat Resolution
extends "res://addons/gut/test.gd" if FileAccess.file_exists("res://addons/gut/test.gd") else RefCounted

func test_melee_combat_resolution() -> void:
	var attacker: Unit = Unit.new(1, Unit.UnitType.WARRIOR, 0, HexCoord.new(1, 1))
	var defender: Unit = Unit.new(2, Unit.UnitType.WARRIOR, 1, HexCoord.new(1, 2)) # Melee range = 1
	
	var result: Dictionary = CombatResolver.resolve_combat(attacker, defender)
	
	assert_true(result.get("damage_dealt", 0) > 0, "Attacker must deal damage to defender")
	assert_true(defender.hp < defender.max_hp, "Defender HP must decrease after combat")
	assert_true(result.get("counter_damage", 0) > 0, "Defender in melee range must counter attack")
	assert_true(attacker.hp < attacker.max_hp, "Attacker HP must decrease from counter attack")

func test_ranged_combat_resolution() -> void:
	var archer: Unit = Unit.new(1, Unit.UnitType.ARCHER, 0, HexCoord.new(1, 1))
	var warrior: Unit = Unit.new(2, Unit.UnitType.WARRIOR, 1, HexCoord.new(1, 3)) # Range = 2
	
	var result: Dictionary = CombatResolver.resolve_combat(archer, warrior)
	
	assert_true(result.get("damage_dealt", 0) > 0, "Archer must deal damage at distance 2")
	assert_eq(result.get("counter_damage", 0), 0, "Warrior with range 1 cannot counter attack at distance 2")
