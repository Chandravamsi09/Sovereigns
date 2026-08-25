# Core Deterministic Combat Resolution Engine
class_name CombatResolver
extends RefCounted

signal combat_occurred(attacker_id: int, defender_id: int, damage_dealt: int, counter_damage: int)

static func resolve_combat(attacker: Unit, defender: Unit, target_tile: TileData = null) -> Dictionary:
	if attacker == null or defender == null or not attacker.is_alive() or not defender.is_alive():
		return {"damage_dealt": 0, "counter_damage": 0, "defender_killed": false, "attacker_killed": false}
		
	var dist: int = attacker.location.distance_to(defender.location)
	if dist > attacker.attack_range:
		return {"damage_dealt": 0, "counter_damage": 0, "defender_killed": false, "attacker_killed": false}
		
	# Terrain Defense Bonus
	var def_bonus: float = 1.0
	if target_tile != null:
		if target_tile.feature == TileData.Feature.FOREST or target_tile.feature == TileData.Feature.HILLS:
			def_bonus = 1.25 # +25% defense
			
	var effective_defense: float = float(defender.defense_power) * def_bonus
	var damage_dealt: int = max(1, int(float(attacker.attack_power) * (float(attacker.hp) / float(attacker.max_hp)) - effective_defense * 0.5))
	
	defender.take_damage(damage_dealt)
	var defender_killed: bool = not defender.is_alive()
	
	var counter_damage: int = 0
	var attacker_killed: bool = false
	
	# Counter attack if melee range and defender survived
	if not defender_killed and dist <= defender.attack_range:
		counter_damage = max(1, int(float(defender.attack_power) * 0.5 * (float(defender.hp) / float(defender.max_hp)) - float(attacker.defense_power) * 0.3))
		attacker.take_damage(counter_damage)
		attacker_killed = not attacker.is_alive()
		
	attacker.action_points = 0
	attacker.current_movement = 0
	
	return {
		"damage_dealt": damage_dealt,
		"counter_damage": counter_damage,
		"defender_killed": defender_killed,
		"attacker_killed": attacker_killed
	}
