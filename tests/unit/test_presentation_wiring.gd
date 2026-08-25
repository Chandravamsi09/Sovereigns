# GUT Unit Tests for Presentation Layer Wiring
extends "res://addons/gut/test.gd" if FileAccess.file_exists("res://addons/gut/test.gd") else RefCounted

func test_terrain_renderer_world_coordinate_conversion() -> void:
	var renderer: HexTerrainRenderer = HexTerrainRenderer.new()
	var coord: HexCoord = HexCoord.new(0, 0)
	var world_pos: Vector3 = renderer.hex_to_world(coord)
	
	assert_eq(world_pos, Vector3.ZERO, "HexCoord(0,0) must map to World Vector3(0,0,0)")
	
	var coord_r: HexCoord = HexCoord.new(0, 2)
	var world_pos_r: Vector3 = renderer.hex_to_world(coord_r)
	assert_true(world_pos_r.z > 0, "Positive R row coordinate must increase Z world offset")

func test_rts_camera_zoom_clamping() -> void:
	var cam: RTSCamera = RTSCamera.new()
	cam.min_zoom = 5.0
	cam.max_zoom = 40.0
	cam.current_zoom = 10.0
	
	cam.process_zoom(-50.0, 0.1) # Extreme zoom in
	assert_eq(cam.current_zoom, 5.0, "Camera zoom must clamp to min_zoom")
	
	cam.process_zoom(100.0, 0.1) # Extreme zoom out
	assert_eq(cam.current_zoom, 40.0, "Camera zoom must clamp to max_zoom")
