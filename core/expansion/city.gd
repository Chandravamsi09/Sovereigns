# Core Settlement / City Model
class_name City
extends RefCounted

signal population_changed(new_pop: int)
signal production_completed(item_name: String)

var city_id: int = 0
var city_name: String = "Capital"
var owner_player_id: int = 0
var location: HexCoord

var population: int = 1
var stored_food: int = 0
var food_threshold: int = 15

var current_production_item: String = ""
var stored_production: int = 0
var production_cost: int = 0

# Territory claimed by this city (Array of HexCoord)
var claimed_tiles: Array[HexCoord] = []

func _init(p_id: int = 0, p_name: String = "Capital", p_owner: int = 0, p_loc: HexCoord = null) -> void:
	city_id = p_id
	city_name = p_name
	owner_player_id = p_owner
	location = p_loc if p_loc != null else HexCoord.new(0, 0)
	claimed_tiles.append(location)

func process_turn(grid: HexGrid) -> void:
	var yields: Dictionary = calculate_city_yields(grid)
	
	# Growth
	stored_food += yields.get("food", 0)
	if stored_food >= food_threshold:
		stored_food -= food_threshold
		population += 1
		food_threshold = int(food_threshold * 1.5)
		population_changed.emit(population)
		
	# Production
	if current_production_item != "":
		stored_production += yields.get("production", 0)
		if stored_production >= production_cost:
			var completed: String = current_production_item
			stored_production = 0
			current_production_item = ""
			production_cost = 0
			production_completed.emit(completed)

func set_production(item_name: String, cost: int) -> void:
	current_production_item = item_name
	production_cost = cost
	stored_production = 0

func calculate_city_yields(grid: HexGrid) -> Dictionary:
	var total_food: int = 2 # City center base yield
	var total_prod: int = 1
	var total_gold: int = 1
	var total_science: int = 1
	
	if grid != null:
		for coord in claimed_tiles:
			var tile: TileData = grid.get_tile(coord)
			if tile != null:
				var y: Dictionary = tile.get_total_yields()
				total_food += y.get("food", 0)
				total_prod += y.get("production", 0)
				total_gold += y.get("gold", 0)
				total_science += y.get("science", 0)
				
	return {
		"food": total_food,
		"production": total_prod,
		"gold": total_gold,
		"science": total_science
	}

func to_dict() -> Dictionary:
	var tiles_arr: Array = []
	for t in claimed_tiles:
		tiles_arr.append(t.to_dict())
	return {
		"city_id": city_id,
		"city_name": city_name,
		"owner_player_id": owner_player_id,
		"location": location.to_dict(),
		"population": population,
		"stored_food": stored_food,
		"food_threshold": food_threshold,
		"current_production_item": current_production_item,
		"stored_production": stored_production,
		"production_cost": production_cost,
		"claimed_tiles": tiles_arr
	}

static func from_dict(dict: Dictionary) -> City:
	var loc: HexCoord = HexCoord.from_dict(dict.get("location", {}))
	var city: City = City.new(
		dict.get("city_id", 0),
		dict.get("city_name", "Capital"),
		dict.get("owner_player_id", 0),
		loc
	)
	city.population = dict.get("population", 1)
	city.stored_food = dict.get("stored_food", 0)
	city.food_threshold = dict.get("food_threshold", 15)
	city.current_production_item = dict.get("current_production_item", "")
	city.stored_production = dict.get("stored_production", 0)
	city.production_cost = dict.get("production_cost", 0)
	
	city.claimed_tiles.clear()
	for t_dict in dict.get("claimed_tiles", []):
		city.claimed_tiles.append(HexCoord.from_dict(t_dict))
	return city
