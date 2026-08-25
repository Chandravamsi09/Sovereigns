# GUT Unit Tests for Trade Route Engine
extends "res://addons/gut/test.gd" if FileAccess.file_exists("res://addons/gut/test.gd") else RefCounted

func test_trade_route_yield_calculation() -> void:
	var tr: TradeRoute = TradeRoute.new(1, 10, 20, 0, 8)
	var yields: Dictionary = tr.get_turn_yields()
	
	assert_eq(yields.get("gold", 0), 7, "Gold yield for distance 8 must be 3 + (8/2) = 7")
	assert_eq(yields.get("food", 0), 2, "Food yield must be 2")

func test_trade_route_serialization() -> void:
	var tr: TradeRoute = TradeRoute.new(5, 101, 102, 1, 12)
	
	var data: Dictionary = tr.to_dict()
	var restored: TradeRoute = TradeRoute.from_dict(data)
	
	assert_eq(restored.route_id, 5, "Restored route ID must match")
	assert_eq(restored.origin_city_id, 101, "Restored origin city ID must match")
	assert_eq(restored.destination_city_id, 102, "Restored destination city ID must match")
	assert_eq(restored.path_distance, 12, "Restored distance must match")
