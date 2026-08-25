# Presentation / VFX: WorldEnvironment Lighting & Post-Processing Stack
class_name WorldEnvSetup
extends Node3D

var world_environment: WorldEnvironment
var sun_light: DirectionalLight3D

func _ready() -> void:
	_setup_lighting_and_environment()

func _setup_lighting_and_environment() -> void:
	# Directional Sun Light
	sun_light = DirectionalLight3D.new()
	sun_light.name = "SunLight"
	sun_light.rotation_degrees = Vector3(-45, 30, 0)
	sun_light.shadow_enabled = true
	add_child(sun_light)
	
	# WorldEnvironment with Post-Processing Stack
	world_environment = WorldEnvironment.new()
	world_environment.name = "WorldEnvironment"
	
	var env: Environment = Environment.new()
	env.background_mode = Environment.BG_CLEAR_COLOR
	
	# Glow / Bloom
	env.glow_enabled = true
	env.glow_intensity = 0.8
	env.glow_bloom = 0.2
	
	# SSAO & SSR
	env.ssao_enabled = true
	env.ssr_enabled = true
	
	world_environment.environment = env
	add_child(world_environment)
