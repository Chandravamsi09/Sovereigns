# GUT Unit Tests for Buildings & Infrastructure Engine
extends "res://addons/gut/test.gd" if FileAccess.file_exists("res://addons/gut/test.gd") else RefCounted

func test_building_catalog_creation() -> void:
	var catalog: Dictionary = Building.create_catalog()
	assert_true(catalog.has("granary"), "Catalog must contain granary")
	assert_true(catalog.has("library"), "Catalog must contain library")
	
	var library: Building = catalog["library"]
	assert_eq(library.science_bonus, 3, "Library must give +3 Science bonus")
	assert_eq(library.prerequisite_tech, "writing", "Library prerequisite must be writing")

func test_building_serialization() -> void:
	var catalog: Dictionary = Building.create_catalog()
	var forge: Building = catalog["forge"]
	
	var data: Dictionary = forge.to_dict()
	var restored: Building = Building.from_dict(data)
	
	assert_eq(restored.id, "forge", "Restored ID must match")
	assert_eq(restored.production_bonus, 3, "Restored production bonus must match")
	assert_eq(restored.prerequisite_tech, "iron_working", "Restored prerequisite tech must match")
