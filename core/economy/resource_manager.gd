# Core Resource & Player Treasury Economy Model
class_name ResourceManager
extends RefCounted

signal treasury_changed(player_id: int, new_gold: int)
signal research_progressed(player_id: int, total_science: int)

var player_id: int = 0

# Core Stockpiles
var gold: int = 100
var science: int = 0
var culture: int = 0

# Net Turn Incomes
var gold_per_turn: int = 10
var science_per_turn: int = 5
var culture_per_turn: int = 2
var upkeep_per_turn: int = 0

func _init(p_player_id: int = 0) -> void:
	player_id = p_player_id

func process_turn_yields() -> void:
	var net_gold: int = gold_per_turn - upkeep_per_turn
	gold = max(0, gold + net_gold)
	science += science_per_turn
	culture += culture_per_turn
	
	treasury_changed.emit(player_id, gold)
	research_progressed.emit(player_id, science)

func can_afford(cost_gold: int) -> bool:
	return gold >= cost_gold

func spend_gold(amount: int) -> bool:
	if can_afford(amount):
		gold -= amount
		treasury_changed.emit(player_id, gold)
		return true
	return false

func add_gold(amount: int) -> void:
	gold += amount
	treasury_changed.emit(player_id, gold)

func to_dict() -> Dictionary:
	return {
		"player_id": player_id,
		"gold": gold,
		"science": science,
		"culture": culture,
		"gold_per_turn": gold_per_turn,
		"science_per_turn": science_per_turn,
		"culture_per_turn": culture_per_turn,
		"upkeep_per_turn": upkeep_per_turn
	}

static func from_dict(dict: Dictionary) -> ResourceManager:
	var rm: ResourceManager = ResourceManager.new(dict.get("player_id", 0))
	rm.gold = dict.get("gold", 100)
	rm.science = dict.get("science", 0)
	rm.culture = dict.get("culture", 0)
	rm.gold_per_turn = dict.get("gold_per_turn", 10)
	rm.science_per_turn = dict.get("science_per_turn", 5)
	rm.culture_per_turn = dict.get("culture_per_turn", 2)
	rm.upkeep_per_turn = dict.get("upkeep_per_turn", 0)
	return rm
