# Core Military & Civilian Unit Data Model
class_name Unit
extends RefCounted

signal health_changed(new_hp: int, max_hp: int)
signal unit_died()

enum UnitType {
	SETTLER,
	WARRIOR,
	ARCHER,
	CAVALRY,
	SIEGE
}

var unit_id: int = 0
var unit_type: UnitType = UnitType.WARRIOR
var owner_player_id: int = 0
var location: HexCoord

# Combat Stats
var hp: int = 100
var max_hp: int = 100
var attack_power: int = 20
var defense_power: int = 10
var attack_range: int = 1

# Movement Stats
var max_movement: int = 2
var current_movement: int = 2
var action_points: int = 1

func _init(p_id: int = 0, p_type: UnitType = UnitType.WARRIOR, p_owner: int = 0, p_loc: HexCoord = null) -> void:
	unit_id = p_id
	unit_type = p_type
	owner_player_id = p_owner
	location = p_loc if p_loc != null else HexCoord.new(0, 0)
	_apply_type_stats()

func _apply_type_stats() -> void:
	match unit_type:
		UnitType.SETTLER:
			hp = 50
			max_hp = 50
			attack_power = 0
			defense_power = 5
			attack_range = 0
			max_movement = 2
		UnitType.WARRIOR:
			hp = 100
			max_hp = 100
			attack_power = 25
			defense_power = 15
			attack_range = 1
			max_movement = 2
		UnitType.ARCHER:
			hp = 70
			max_hp = 70
			attack_power = 30
			defense_power = 8
			attack_range = 2
			max_movement = 2
		UnitType.CAVALRY:
			hp = 110
			max_hp = 110
			attack_power = 35
			defense_power = 12
			attack_range = 1
			max_movement = 4
		UnitType.SIEGE:
			hp = 80
			max_hp = 80
			attack_power = 50
			defense_power = 5
			attack_range = 3
			max_movement = 1
			
	current_movement = max_movement

func reset_turn_movement() -> void:
	current_movement = max_movement
	action_points = 1

func take_damage(amount: int) -> void:
	hp = max(0, hp - amount)
	health_changed.emit(hp, max_hp)
	if hp <= 0:
		unit_died.emit()

func is_alive() -> bool:
	return hp > 0

func can_move_cost(cost: int) -> bool:
	return current_movement >= cost and action_points > 0

func consume_movement(cost: int) -> void:
	current_movement = max(0, current_movement - cost)

func to_dict() -> Dictionary:
	return {
		"unit_id": unit_id,
		"unit_type": unit_type,
		"owner_player_id": owner_player_id,
		"location": location.to_dict(),
		"hp": hp,
		"max_hp": max_hp,
		"attack_power": attack_power,
		"defense_power": defense_power,
		"attack_range": attack_range,
		"max_movement": max_movement,
		"current_movement": current_movement,
		"action_points": action_points
	}

static func from_dict(dict: Dictionary) -> Unit:
	var loc: HexCoord = HexCoord.from_dict(dict.get("location", {}))
	var u: Unit = Unit.new(
		dict.get("unit_id", 0),
		dict.get("unit_type", UnitType.WARRIOR) as UnitType,
		dict.get("owner_player_id", 0),
		loc
	)
	u.hp = dict.get("hp", 100)
	u.max_hp = dict.get("max_hp", 100)
	u.attack_power = dict.get("attack_power", 25)
	u.defense_power = dict.get("defense_power", 15)
	u.attack_range = dict.get("attack_range", 1)
	u.max_movement = dict.get("max_movement", 2)
	u.current_movement = dict.get("current_movement", 2)
	u.action_points = dict.get("action_points", 1)
	return u
