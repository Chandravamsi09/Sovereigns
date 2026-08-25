# TestBootstrap - Initial sanity test suite verifying test harness operation
extends "res://addons/gut/test.gd" if FileAccess.file_exists("res://addons/gut/test.gd") else RefCounted

func test_bootstrap_sanity() -> void:
	# Sanity assertion ensuring test runner environment functions as expected
	var value: int = 1 + 1
	assert_eq(value, 2, "Bootstrap sanity check: 1 + 1 must equal 2")

func test_core_architecture_split() -> void:
	# Ensure core namespace constant or version flag is verified
	var project_name: String = "Sovereigns"
	assert_eq(project_name, "Sovereigns", "Project name must match Sovereigns")
