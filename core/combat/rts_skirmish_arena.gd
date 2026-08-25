# Core Real-Time Skirmish Battle Mode Simulator
class_name RTSSkirmishArena
extends RefCounted

signal skirmish_completed(winner_player_id: int)

var army_a: Array[Unit] = []
var army_b: Array[Unit] = []
var player_a_id: int = 0
var player_b_id: int = 1

var is_finished: bool = false
var winner_id: int = -1

func _init(p_army_a: Array[Unit], p_army_b: Array[Unit], p_id_a: int = 0, p_id_b: int = 1) -> void:
	for u in p_army_a:
		army_a.append(u)
	for u in p_army_b:
		army_b.append(u)
	player_a_id = p_id_a
	player_b_id = p_id_b

func simulate_tick(dt: float) -> bool:
	if is_finished:
		return true
		
	# Clean dead units
	army_a = army_a.filter(func(u: Unit): return u.is_alive())
	army_b = army_b.filter(func(u: Unit): return u.is_alive())
	
	if army_a.is_empty():
		is_finished = true
		winner_id = player_b_id
		skirmish_completed.emit(winner_id)
		return true
		
	if army_b.is_empty():
		is_finished = true
		winner_id = player_a_id
		skirmish_completed.emit(winner_id)
		return true
		
	# Simulate engagement step
	for u_a in army_a:
		if u_a.is_alive() and not army_b.is_empty():
			var target_b: Unit = army_b[0]
			CombatResolver.resolve_combat(u_a, target_b)
			
	for u_b in army_b:
		if u_b.is_alive() and not army_a.is_empty():
			var target_a: Unit = army_a[0]
			CombatResolver.resolve_combat(u_b, target_a)
			
	return false

func run_full_skirmish(max_ticks: int = 100) -> int:
	var tick: int = 0
	while not is_finished and tick < max_ticks:
		simulate_tick(0.1)
		tick += 1
	return winner_id
