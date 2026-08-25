# Core Tile & Terrain Data Model
class_name TileData
extends RefCounted

enum Biome {
	PLAINS,
	GRASSLAND,
	DESERT,
	TUNDRA,
	SNOW,
	OCEAN,
	COAST,
	MOUNTAIN
}

enum Feature {
	NONE,
	FOREST,
	HILLS,
	RIVER,
	MARSH,
	OASIS
}

var coord: HexCoord
var biome: Biome = Biome.PLAINS
var feature: Feature = Feature.NONE
var movement_cost: int = 1
var is_passable: bool = true

# Yields
var food_yield: int = 1
var production_yield: int = 1
var gold_yield: int = 0
var science_yield: int = 0

# Ownership and state
var owner_player_id: int = -1
var city_id: int = -1

func _init(p_coord: HexCoord = null, p_biome: Biome = Biome.PLAINS) -> void:
	coord = p_coord if p_coord != null else HexCoord.new(0, 0)
	biome = p_biome
	_apply_default_yields()

func _apply_default_yields() -> void:
	match biome:
		Biome.GRASSLAND:
			food_yield = 2
			production_yield = 0
			gold_yield = 0
			movement_cost = 1
		Biome.PLAINS:
			food_yield = 1
			production_yield = 1
			gold_yield = 0
			movement_cost = 1
		Biome.DESERT:
			food_yield = 0
			production_yield = 0
			gold_yield = 0
			movement_cost = 1
		Biome.TUNDRA:
			food_yield = 1
			production_yield = 0
			gold_yield = 0
			movement_cost = 1
		Biome.SNOW:
			food_yield = 0
			production_yield = 0
			gold_yield = 0
			movement_cost = 1
		Biome.OCEAN:
			food_yield = 1
			production_yield = 0
			gold_yield = 1
			movement_cost = 1
		Biome.COAST:
			food_yield = 1
			production_yield = 0
			gold_yield = 2
			movement_cost = 1
		Biome.MOUNTAIN:
			food_yield = 0
			production_yield = 0
			gold_yield = 0
			movement_cost = 99
			is_passable = false

func set_feature(p_feature: Feature) -> void:
	feature = p_feature
	match feature:
		Feature.FOREST:
			production_yield += 1
			movement_cost += 1
		Feature.HILLS:
			production_yield += 1
			movement_cost += 1
		Feature.MARSH:
			food_yield += 1
			movement_cost += 1

func get_total_yields() -> Dictionary:
	return {
		"food": food_yield,
		"production": production_yield,
		"gold": gold_yield,
		"science": science_yield
	}

func to_dict() -> Dictionary:
	return {
		"coord": coord.to_dict(),
		"biome": biome,
		"feature": feature,
		"owner_player_id": owner_player_id,
		"city_id": city_id
	}

static func from_dict(dict: Dictionary) -> TileData:
	var c: HexCoord = HexCoord.from_dict(dict.get("coord", {}))
	var tile: TileData = TileData.new(c, dict.get("biome", Biome.PLAINS) as Biome)
	tile.set_feature(dict.get("feature", Feature.NONE) as Feature)
	tile.owner_player_id = dict.get("owner_player_id", -1)
	tile.city_id = dict.get("city_id", -1)
	return tile
