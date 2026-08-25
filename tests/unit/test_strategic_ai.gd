# GUT Unit Tests for Strategic Utility AI & Opponents
extends "res://addons/gut/test.gd" if FileAccess.file_exists("res://addons/gut/test.gd") else RefCounted

func test_settlement_site_utility_evaluation() -> void:
	var grid: HexGrid = HexGrid.new(10, 10)
	var ai: UtilityAI = UtilityAI.new(1, UtilityAI.DifficultyTier.MEDIUM)
	
	var site_score: float = ai.evaluate_settlement_site(grid, HexCoord.new(5, 5))
	assert_true(site_score > 0.0, "Settlement site evaluation score must be positive for valid plains tile")

func test_tech_selection_by_difficulty() -> void:
	var tree: TechTree = TechTree.new(1)
	var easy_ai: UtilityAI = UtilityAI.new(1, UtilityAI.DifficultyTier.EASY)
	var hard_ai: UtilityAI = UtilityAI.new(1, UtilityAI.DifficultyTier.HARD)
	
	var tech_easy: String = easy_ai.select_best_tech(tree)
	var tech_hard: String = hard_ai.select_best_tech(tree)
	
	assert_true(tech_easy != "", "Easy AI must select a valid technology")
	assert_true(tech_hard != "", "Hard AI must select a valid technology")

func test_strategic_agent_execution() -> void:
	var grid: HexGrid = HexGrid.new(10, 10)
	var tree: TechTree = TechTree.new(1)
	var rm: ResourceManager = ResourceManager.new(1)
	rm.gold = 100
	
	var agent: StrategicAIAgent = StrategicAIAgent.new(1, UtilityAI.DifficultyTier.HARD)
	agent.execute_turn(grid, tree, rm)
	
	assert_true(tree.current_research_tech_id != "", "AI must assign active research on turn execution")
	assert_eq(rm.gold, 115, "Hard AI must receive gold bonus on turn execution")
