# Presentation Layer: 4X RTS Camera Controller
class_name RTSCamera
extends Node3D

@export var move_speed: float = 20.0
@export var zoom_speed: float = 5.0
@export var min_zoom: float = 5.0
@export var max_zoom: float = 40.0
@export var rotation_speed: float = 2.0

var camera: Camera3D
var current_zoom: float = 20.0
var target_position: Vector3 = Vector3.ZERO

func _ready() -> void:
	target_position = global_position
	_setup_camera()

func _setup_camera() -> void:
	camera = Camera3D.new()
	camera.name = "Camera3D"
	camera.position = Vector3(0, current_zoom, current_zoom * 0.75)
	camera.rotation_degrees = Vector3(-55, 0, 0)
	add_child(camera)

func process_movement(input_dir: Vector2, delta: float) -> void:
	var move_vector: Vector3 = (transform.basis.z * input_dir.y + transform.basis.x * input_dir.x).normalized()
	target_position += move_vector * move_speed * delta
	global_position = global_position.lerp(target_position, 10.0 * delta)

func process_zoom(zoom_delta: float, delta: float) -> void:
	current_zoom = clampf(current_zoom + zoom_delta * zoom_speed, min_zoom, max_zoom)
	if camera != null:
		var target_cam_pos: Vector3 = Vector3(0, current_zoom, current_zoom * 0.75)
		camera.position = camera.position.lerp(target_cam_pos, 10.0 * delta)
