# Game Balance Matrix & System Tuning Configuration
class_name BalanceConfig
extends RefCounted

const BASE_CITY_FOOD_THRESHOLD: int = 15
const FOOD_GROWTH_MULTIPLIER: float = 1.5

const BASE_UNITS_UPKEEP: Dictionary = {
	"SETTLER": 0,
	"WARRIOR": 1,
	"ARCHER": 1,
	"CAVALRY": 2,
	"SIEGE": 3
}

const TECH_RESEARCH_COSTS: Dictionary = {
	"agriculture": 30,
	"pottery": 50,
	"mining": 50,
	"writing": 80,
	"bronze_working": 80,
	"iron_working": 120,
	"currency": 120,
	"mathematics": 140
}

static func get_tech_cost(tech_id: String) -> int:
	return TECH_RESEARCH_COSTS.get(tech_id, 50)
