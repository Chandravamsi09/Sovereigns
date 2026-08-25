# Presentation Layer: Main HUD & UI Controller
class_name HUDController
extends Control

signal end_turn_pressed()

var gold_label: Label
var science_label: Label
var turn_label: Label
var end_turn_button: Button

func _ready() -> void:
	_create_ui_layout()

func _create_ui_layout() -> void:
	# Top Resource Bar Panel
	var top_bar: PanelContainer = PanelContainer.new()
	top_bar.name = "TopBar"
	top_bar.anchor_right = 1.0
	top_bar.custom_minimum_size = Vector2(0, 40)
	add_child(top_bar)
	
	var hbox: HBoxContainer = HBoxContainer.new()
	top_bar.add_child(hbox)
	
	gold_label = Label.new()
	gold_label.text = "Gold: 100 (+10)"
	hbox.add_child(gold_label)
	
	science_label = Label.new()
	science_label.text = "Science: 0 (+5)"
	hbox.add_child(science_label)
	
	turn_label = Label.new()
	turn_label.text = "Turn: 1"
	hbox.add_child(turn_label)
	
	# Action Panel (Bottom Right)
	end_turn_button = Button.new()
	end_turn_button.name = "EndTurnButton"
	end_turn_button.text = "End Turn"
	end_turn_button.anchor_left = 1.0
	end_turn_button.anchor_top = 1.0
	end_turn_button.anchor_right = 1.0
	end_turn_button.anchor_bottom = 1.0
	end_turn_button.offset_left = -120
	end_turn_button.offset_top = -60
	end_turn_button.offset_right = -20
	end_turn_button.offset_bottom = -20
	end_turn_button.pressed.connect(_on_end_turn_clicked)
	add_child(end_turn_button)

func update_resources(gold: int, gold_per_turn: int, science: int, science_per_turn: int) -> void:
	if gold_label != null:
		gold_label.text = "Gold: %d (+%d)" % [gold, gold_per_turn]
	if science_label != null:
		science_label.text = "Science: %d (+%d)" % [science, science_per_turn]

func update_turn(turn_num: int) -> void:
	if turn_label != null:
		turn_label.text = "Turn: %d" % turn_num

func _on_end_turn_clicked() -> void:
	end_turn_pressed.emit()
