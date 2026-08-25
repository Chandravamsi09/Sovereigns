# GUT Unit Tests for VFX Stack & Shaders
extends "res://addons/gut/test.gd" if FileAccess.file_exists("res://addons/gut/test.gd") else RefCounted

func test_world_env_post_processing_setup() -> void:
	var env_node: WorldEnvSetup = WorldEnvSetup.new()
	env_node._ready()
	
	assert_not_null(env_node.world_environment, "WorldEnvironment node must be created")
	var env: Environment = env_node.world_environment.environment
	assert_not_null(env, "Environment resource must exist")
	assert_true(env.glow_enabled, "Glow must be enabled in post-processing environment")
	assert_true(env.ssao_enabled, "SSAO must be enabled")
	assert_true(env.ssr_enabled, "SSR must be enabled")

func test_combat_sparks_emitter_initialization() -> void:
	var sparks: CombatSparks = CombatSparks.new()
	sparks._ready()
	
	assert_eq(sparks.amount, 32, "GPUParticles amount must be 32")
	assert_true(sparks.one_shot, "Combat sparks must be set to one_shot")
