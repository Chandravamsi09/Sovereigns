# GUT Unit Tests for Tech Tree DAG Engine
extends "res://addons/gut/test.gd" if FileAccess.file_exists("res://addons/gut/test.gd") else RefCounted

func test_tech_tree_prerequisite_validation() -> void:
	var tree: TechTree = TechTree.new(0)
	
	assert_true(tree.can_research("agriculture"), "Root tech Agriculture with no prerequisites must be researchable")
	assert_false(tree.can_research("writing"), "Writing must not be researchable before Pottery is unlocked")
	
	# Unlock agriculture and pottery
	tree.set_current_research("agriculture")
	tree.add_science_points(30)
	assert_true(tree.is_unlocked("agriculture"), "Agriculture must be unlocked after 30 science points")
	
	assert_true(tree.can_research("pottery"), "Pottery must now be researchable after Agriculture unlock")
	assert_false(tree.can_research("writing"), "Writing still requires Pottery")

func test_tech_tree_completion_and_events() -> void:
	var tree: TechTree = TechTree.new(0)
	tree.unlocked_techs["agriculture"] = true
	tree.unlocked_techs["pottery"] = true
	
	assert_true(tree.set_current_research("writing"), "Writing should be set as active research")
	tree.add_science_points(50)
	assert_false(tree.is_unlocked("writing"), "Writing should require 80 science points total")
	
	tree.add_science_points(30)
	assert_true(tree.is_unlocked("writing"), "Writing must be unlocked after reaching 80 science points")
	assert_eq(tree.current_research_tech_id, "", "Current active research must clear on unlock")

func test_tech_tree_serialization() -> void:
	var tree: TechTree = TechTree.new(1)
	tree.unlocked_techs["agriculture"] = true
	tree.unlocked_techs["mining"] = true
	tree.set_current_research("bronze_working")
	tree.add_science_points(40)
	
	var data: Dictionary = tree.to_dict()
	var restored: TechTree = TechTree.from_dict(data)
	
	assert_true(restored.is_unlocked("agriculture"), "Restored tree must retain unlocked Agriculture")
	assert_true(restored.is_unlocked("mining"), "Restored tree must retain unlocked Mining")
	assert_eq(restored.current_research_tech_id, "bronze_working", "Restored active research must match")
	assert_eq(restored.research_progress, 40, "Restored progress must match")
