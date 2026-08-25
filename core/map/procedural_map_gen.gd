# Core Engine-Agnostic Deterministic Procedural Map Generator
class_name ProceduralMapGen
extends RefCounted

var seed_value: int = 1337
var elevation_noise: FastNoiseLite
var moisture_noise: FastNoiseLite

func _init(p_seed: int = 1337) -> void:
	seed_value = p_seed
	_setup_noises()

func _setup_noises() -> void:
	elevation_noise = FastNoiseLite.new()
	elevation_noise.seed = seed_value
	elevation_noise.frequency = 0.05
	elevation_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	
	moisture_noise = FastNoiseLite.new()
	moisture_noise.seed = seed_value + 9999
	moisture_noise.frequency = 0.08
	moisture_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX

func generate_map(width: int = 32, height: int = 32) -> HexGrid:
	var grid: HexGrid = HexGrid.new(width, height)
	
	for r in range(height):
		for q in range(width):
			var coord: HexCoord = HexCoord.new(q, r)
			var elev: float = (elevation_noise.get_noise_2d(q, r) + 1.0) / 2.0
			var moist: float = (moisture_noise.get_noise_2d(q, r) + 1.0) / 2.0
			
			var biome: TileData.Biome = _determine_biome(elev, moist)
			var tile: TileData = TileData.new(coord, biome)
			
			var feat: TileData.Feature = _determine_feature(elev, moist, biome)
			tile.set_feature(feat)
			
			grid.set_tile(coord, tile)
			
	return grid

func _determine_biome(elev: float, moist: float) -> TileData.Biome:
	if elev < 0.3:
		return TileData.Biome.OCEAN
	elif elev < 0.38:
		return TileData.Biome.COAST
	elif elev > 0.82:
		return TileData.Biome.MOUNTAIN
	elif elev < 0.5:
		if moist < 0.3:
			return TileData.Biome.DESERT
		elif moist > 0.7:
			return TileData.Biome.GRASSLAND
		else:
			return TileData.Biome.PLAINS
	else:
		if moist < 0.3:
			return TileData.Biome.TUNDRA
		elif moist < 0.7:
			return TileData.Biome.PLAINS
		else:
			return TileData.Biome.GRASSLAND

func _determine_feature(elev: float, moist: float, biome: TileData.Biome) -> TileData.Feature:
	if biome == TileData.Biome.OCEAN or biome == TileData.Biome.COAST or biome == TileData.Biome.MOUNTAIN:
		return TileData.Feature.NONE
		
	if elev > 0.65 and elev <= 0.82:
		return TileData.Feature.HILLS
		
	if moist > 0.6 and biome != TileData.Biome.DESERT:
		return TileData.Feature.FOREST
		
	if biome == TileData.Biome.DESERT and moist > 0.75:
		return TileData.Feature.OASIS
		
	return TileData.Feature.NONE
