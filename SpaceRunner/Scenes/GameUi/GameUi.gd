extends Control


class_name GameUi


@onready var game_over: ColorRect = $GameOver
@onready var label: Label = $GameOver/VB/Label
@onready var game_over_scored: Label = $GameOver/VB/GameOverScored
@onready var press_shoot: Label = $GameOver/VB/PressShoot
@onready var score_label: Label = $MarginContainer/ScoreLabel

@onready var pause_menu: PanelContainer = $PauseMenu

func _ready() -> void:
	get_tree().paused = false	
	
	
func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("pause"):
		pause_menu.visible=!pause_menu.visible
		get_tree().paused = pause_menu.visible
