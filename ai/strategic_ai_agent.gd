# Strategic AI Agent Execution Controller
class_name StrategicAIAgent
extends RefCounted

signal ai_turn_completed(player_id: int)

var player_id: int = 1
var utility_evaluator: UtilityAI

func _init(p_player_id: int = 1, difficulty: UtilityAI.DifficultyTier = UtilityAI.DifficultyTier.MEDIUM) -> void:
	player_id = p_player_id
	utility_evaluator = UtilityAI.new(player_id, difficulty)

func execute_turn(grid: HexGrid, tech_tree: TechTree, resource_mgr: ResourceManager) -> void:
	if tech_tree != null and tech_tree.current_research_tech_id == "":
		var best_tech: String = utility_evaluator.select_best_tech(tech_tree)
		if best_tech != "":
			tech_tree.set_current_research(best_tech)
			
	if resource_mgr != null and utility_evaluator.difficulty == UtilityAI.DifficultyTier.HARD:
		# Apply Hard difficulty AI handicap bonus
		resource_mgr.add_gold(15)
		
	ai_turn_completed.emit(player_id)
