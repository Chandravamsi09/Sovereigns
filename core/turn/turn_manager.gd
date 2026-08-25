# Core Turn Manager State Machine & Action Queue
class_name TurnManager
extends RefCounted

signal turn_started(turn_number: int, active_player_id: int)
signal phase_changed(new_phase: TurnPhase)
signal turn_ended(turn_number: int, active_player_id: int)

enum TurnPhase {
	START_TURN,
	ACTION_PHASE,
	END_TURN,
	AI_PROCESSING
}

var current_turn: int = 1
var active_player_index: int = 0
var player_ids: Array[int] = [0, 1] # Player 0 (Human), Player 1 (AI)
var current_phase: TurnPhase = TurnPhase.START_TURN

# Track turn action log for replay / determinism
var action_history: Array[Dictionary] = []

func _init(p_player_ids: Array[int] = [0, 1]) -> void:
	if p_player_ids.size() > 0:
		player_ids = p_player_ids.duplicate()
	start_game()

func start_game() -> void:
	current_turn = 1
	active_player_index = 0
	_set_phase(TurnPhase.START_TURN)

func get_active_player_id() -> int:
	if player_ids.is_empty():
		return -1
	return player_ids[active_player_index]

func advance_phase() -> void:
	match current_phase:
		TurnPhase.START_TURN:
			_set_phase(TurnPhase.ACTION_PHASE)
		TurnPhase.ACTION_PHASE:
			_set_phase(TurnPhase.END_TURN)
			end_current_player_turn()
		TurnPhase.END_TURN:
			_next_player()
		TurnPhase.AI_PROCESSING:
			_set_phase(TurnPhase.END_TURN)
			end_current_player_turn()

func end_current_player_turn() -> void:
	var ending_player_id: int = get_active_player_id()
	turn_ended.emit(current_turn, ending_player_id)
	_next_player()

func _next_player() -> void:
	active_player_index += 1
	if active_player_index >= player_ids.size():
		active_player_index = 0
		current_turn += 1
	
	_set_phase(TurnPhase.START_TURN)
	turn_started.emit(current_turn, get_active_player_id())

func _set_phase(new_phase: TurnPhase) -> void:
	current_phase = new_phase
	phase_changed.emit(current_phase)

func log_action(action_type: String, data: Dictionary) -> void:
	var entry: Dictionary = {
		"turn": current_turn,
		"player_id": get_active_player_id(),
		"phase": current_phase,
		"type": action_type,
		"data": data
	}
	action_history.append(entry)

func to_dict() -> Dictionary:
	return {
		"current_turn": current_turn,
		"active_player_index": active_player_index,
		"player_ids": player_ids.duplicate(),
		"current_phase": current_phase,
		"action_history": action_history.duplicate()
	}

static func from_dict(dict: Dictionary) -> TurnManager:
	var players: Array[int] = []
	for p in dict.get("player_ids", [0, 1]):
		players.append(int(p))
	
	var tm: TurnManager = TurnManager.new(players)
	tm.current_turn = dict.get("current_turn", 1)
	tm.active_player_index = dict.get("active_player_index", 0)
	tm.current_phase = dict.get("current_phase", TurnPhase.START_TURN) as TurnPhase
	var history: Array = dict.get("action_history", [])
	tm.action_history.clear()
	for item in history:
		tm.action_history.append(item)
	return tm
