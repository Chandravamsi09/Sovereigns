# Core Strategic Utility-Based AI Evaluator
class_name UtilityAI
extends RefCounted

enum DifficultyTier {
	EASY,
	MEDIUM,
	HARD
}

var player_id: int = 1
var difficulty: DifficultyTier = DifficultyTier.MEDIUM

func _init(p_player_id: int = 1, p_diff: DifficultyTier = DifficultyTier.MEDIUM) -> void:
	player_id = p_player_id
	difficulty = p_diff

func evaluate_settlement_site(grid: HexGrid, candidate: HexCoord) -> float:
	if grid == null or candidate == null:
		return 0.0
		
	var tile: TileData = grid.get_tile(candidate)
	if tile == null or not tile.is_passable or tile.owner_player_id != -1:
		return 0.0
		
	var ring: Array[TileData] = grid.get_tiles_in_range(candidate, 1)
	var total_score: float = 0.0
	for t in ring:
		var y: Dictionary = t.get_total_yields()
		total_score += y.get("food", 0) * 2.0 + y.get("production", 0) * 1.5 + y.get("gold", 0) * 1.0
		
	# Apply difficulty evaluation depth modifier
	match difficulty:
		DifficultyTier.EASY:
			total_score *= 0.8
		DifficultyTier.HARD:
			total_score *= 1.25
			
	return total_score

func select_best_tech(tech_tree: TechTree) -> String:
	if tech_tree == null:
		return ""
		
	var candidates: Array[String] = []
	for node_id in tech_tree.nodes:
		if tech_tree.can_research(node_id):
			candidates.append(node_id)
			
	if candidates.is_empty():
		return ""
		
	# Prioritize economy / science on Medium/Hard, random on Easy
	if difficulty == DifficultyTier.EASY:
		return candidates[0]
		
	for c in candidates:
		if c == "writing" or c == "agriculture" or c == "currency":
			return c
			
	return candidates[0]
