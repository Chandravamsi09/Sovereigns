# Presentation Layer: Main Game Scene Wiring
class_name MainGameScene
extends Node3D

var grid: HexGrid
var turn_manager: TurnManager
var resource_manager: ResourceManager

var camera: RTSCamera
var terrain_renderer: HexTerrainRenderer
var hud: HUDController

func _ready() -> void:
	_initialize_simulation()
	_initialize_presentation()

func _initialize_simulation() -> void:
	var map_gen: ProceduralMapGen = ProceduralMapGen.new(1337)
	grid = map_gen.generate_map(24, 24)
	turn_manager = TurnManager.new([0, 1])
	resource_manager = ResourceManager.new(0)

func _initialize_presentation() -> void:
	camera = RTSCamera.new()
	camera.name = "RTSCamera"
	add_child(camera)
	
	terrain_renderer = HexTerrainRenderer.new()
	terrain_renderer.name = "HexTerrainRenderer"
	add_child(terrain_renderer)
	terrain_renderer.render_grid(grid)
	
	hud = HUDController.new()
	hud.name = "HUDController"
	add_child(hud)
	hud.end_turn_pressed.connect(_on_end_turn_requested)
	
	_update_hud()

func _on_end_turn_requested() -> void:
	turn_manager.advance_phase()
	resource_manager.process_turn_yields()
	_update_hud()

func _update_hud() -> void:
	if hud != null:
		hud.update_resources(
			resource_manager.gold, resource_manager.gold_per_turn,
			resource_manager.science, resource_manager.science_per_turn
		)
		hud.update_turn(turn_manager.current_turn)
