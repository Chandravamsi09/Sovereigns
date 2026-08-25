# GUT Unit Tests for Resource Economy Manager
extends "res://addons/gut/test.gd" if FileAccess.file_exists("res://addons/gut/test.gd") else RefCounted

func test_resource_yield_processing() -> void:
	var rm: ResourceManager = ResourceManager.new(0)
	rm.gold = 100
	rm.gold_per_turn = 15
	rm.upkeep_per_turn = 5
	rm.science_per_turn = 10
	
	rm.process_turn_yields()
	assert_eq(rm.gold, 110, "Gold treasury must increase by net income (15 - 5 = +10)")
	assert_eq(rm.science, 10, "Science stockpile must increase by science_per_turn (+10)")

func test_spending_and_affordability() -> void:
	var rm: ResourceManager = ResourceManager.new(0)
	rm.gold = 50
	
	assert_true(rm.can_afford(30), "Must be able to afford 30 gold when possessing 50")
	assert_false(rm.can_afford(60), "Must not be able to afford 60 gold when possessing 50")
	
	var success: bool = rm.spend_gold(30)
	assert_true(success, "Spend gold must return true on sufficient funds")
	assert_eq(rm.gold, 20, "Remaining gold treasury must be 20")
	
	var fail: bool = rm.spend_gold(30)
	assert_false(fail, "Spend gold must return false on insufficient funds")
	assert_eq(rm.gold, 20, "Gold treasury must remain unchanged on failed transaction")

func test_resource_serialization() -> void:
	var rm: ResourceManager = ResourceManager.new(1)
	rm.gold = 250
	rm.science = 80
	rm.upkeep_per_turn = 12
	
	var data: Dictionary = rm.to_dict()
	var restored: ResourceManager = ResourceManager.from_dict(data)
	assert_eq(restored.player_id, 1, "Restored player ID must match")
	assert_eq(restored.gold, 250, "Restored gold must match")
	assert_eq(restored.science, 80, "Restored science must match")
	assert_eq(restored.upkeep_per_turn, 12, "Restored upkeep per turn must match")
