# Core Deterministic Save & Load System
class_name SaveSystem
extends RefCounted

const SAVE_VERSION: String = "1.0.0"

static func serialize_game_state(grid: HexGrid, turn_mgr: TurnManager, player_resources: Dictionary) -> String:
	var resources_data: Dictionary = {}
	for p_id in player_resources:
		var rm: ResourceManager = player_resources[p_id] as ResourceManager
		if rm != null:
			resources_data[str(p_id)] = rm.to_dict()
	
	var save_dict: Dictionary = {
		"version": SAVE_VERSION,
		"timestamp": Time.get_unix_time_from_system(),
		"grid": grid.to_dict(),
		"turn_manager": turn_mgr.to_dict(),
		"player_resources": resources_data
	}
	
	return JSON.stringify(save_dict, "\t")

static func deserialize_game_state(json_string: String) -> Dictionary:
	var json: JSON = JSON.new()
	var parse_result: Error = json.parse(json_string)
	if parse_result != OK:
		push_error("SaveSystem: Failed to parse save state JSON. Error: " + str(parse_result))
		return {}
	
	var data: Dictionary = json.data as Dictionary
	var version: String = data.get("version", "")
	assert(version == SAVE_VERSION, "Unsupported save file version: " + version)
	
	var restored_grid: HexGrid = HexGrid.from_dict(data.get("grid", {}))
	var restored_turn_mgr: TurnManager = TurnManager.from_dict(data.get("turn_manager", {}))
	
	var resources_data: Dictionary = data.get("player_resources", {})
	var restored_resources: Dictionary = {}
	for p_id_str in resources_data:
		var p_id: int = int(p_id_str)
		restored_resources[p_id] = ResourceManager.from_dict(resources_data[p_id_str])
	
	return {
		"grid": restored_grid,
		"turn_manager": restored_turn_mgr,
		"player_resources": restored_resources
	}

static func save_to_file(path: String, grid: HexGrid, turn_mgr: TurnManager, player_resources: Dictionary) -> bool:
	var json_str: String = serialize_game_state(grid, turn_mgr, player_resources)
	var file: FileAccess = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_error("SaveSystem: Unable to open file for writing at path: " + path)
		return false
	file.store_string(json_str)
	file.close()
	return true

static func load_from_file(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		push_error("SaveSystem: File does not exist at path: " + path)
		return {}
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {}
	var content: String = file.get_as_text()
	file.close()
	return deserialize_game_state(content)
