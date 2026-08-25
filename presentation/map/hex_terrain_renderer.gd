# Presentation Layer: 3D Hex Grid Terrain Mesh Generator
class_name HexTerrainRenderer
extends Node3D

const HEX_RADIUS: float = 1.0
const HEX_HEIGHT: float = 0.2

var grid_ref: HexGrid

func render_grid(grid: HexGrid) -> void:
	grid_ref = grid
	_clear_rendered_mesh()
	
	if grid == null:
		return
		
	for r in range(grid.height):
		for q in range(grid.width):
			var coord: HexCoord = HexCoord.new(q, r)
			var tile: TileData = grid.get_tile(coord)
			if tile != null:
				_spawn_tile_mesh(tile)

func _clear_rendered_mesh() -> void:
	for child in get_children():
		child.queue_free()

func _spawn_tile_mesh(tile: TileData) -> void:
	var pos: Vector3 = hex_to_world(tile.coord)
	var mesh_instance: MeshInstance3D = MeshInstance3D.new()
	mesh_instance.name = "Tile_%d_%d" % [tile.coord.q, tile.coord.r]
	mesh_instance.position = pos
	
	var cylinder: CylinderMesh = CylinderMesh.new()
	cylinder.top_radius = HEX_RADIUS
	cylinder.bottom_radius = HEX_RADIUS
	cylinder.height = HEX_HEIGHT
	mesh_instance.mesh = cylinder
	
	# Material per biome
	var mat: StandardMaterial3D = StandardMaterial3D.new()
	mat.albedo_color = _get_biome_color(tile.biome)
	mesh_instance.material_override = mat
	
	add_child(mesh_instance)

func hex_to_world(coord: HexCoord) -> Vector3:
	var x: float = HEX_RADIUS * (sqrt(3.0) * coord.q + sqrt(3.0) / 2.0 * coord.r)
	var z: float = HEX_RADIUS * (3.0 / 2.0 * coord.r)
	return Vector3(x, 0.0, z)

func _get_biome_color(biome: TileData.Biome) -> Color:
	match biome:
		TileData.Biome.GRASSLAND:
			return Color(0.2, 0.7, 0.2)
		TileData.Biome.PLAINS:
			return Color(0.7, 0.7, 0.3)
		TileData.Biome.DESERT:
			return Color(0.9, 0.8, 0.4)
		TileData.Biome.TUNDRA:
			return Color(0.6, 0.6, 0.5)
		TileData.Biome.SNOW:
			return Color(0.95, 0.95, 0.95)
		TileData.Biome.OCEAN:
			return Color(0.1, 0.3, 0.8)
		TileData.Biome.COAST:
			return Color(0.2, 0.5, 0.9)
		TileData.Biome.MOUNTAIN:
			return Color(0.4, 0.4, 0.4)
		_:
			return Color.WHITE
