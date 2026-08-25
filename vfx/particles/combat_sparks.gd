# VFX Layer: GPUParticles3D Combat Spark Emitter
class_name CombatSparks
extends GPUParticles3D

func _ready() -> void:
	amount = 32
	lifetime = 0.5
	one_shot = true
	explosiveness = 0.9
	
	var mat: ParticleProcessMaterial = ParticleProcessMaterial.new()
	mat.direction = Vector3(0, 1, 0)
	mat.spread = 45.0
	mat.initial_velocity_min = 2.0
	mat.initial_velocity_max = 5.0
	process_material = mat
	
	var mesh: SphereMesh = SphereMesh.new()
	mesh.radius = 0.05
	mesh.height = 0.1
	draw_pass_1 = mesh

func trigger_impact(at_position: Vector3) -> void:
	global_position = at_position
	restart()
