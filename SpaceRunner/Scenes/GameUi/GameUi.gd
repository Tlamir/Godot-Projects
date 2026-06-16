extends Control


class_name GameUi


@onready var game_over: ColorRect = $GameOver
@onready var label: Label = $GameOver/VB/Label
@onready var game_over_scored: Label = $GameOver/VB/GameOverScored
@onready var press_shoot: Label = $GameOver/VB/PressShoot
@onready var score_label: Label = $MarginContainer/ScoreLabel

@onready var pause_menu: PanelContainer = $PauseMenu
@onready var asteroids_stat: PauseMenuStat = $PauseMenu/VB/VBStats/AsteroidsStat
@onready var ships_stat: PauseMenuStat = $PauseMenu/VB/VBStats/ShipsStat
@onready var game_time_stat: PauseMenuStat = $PauseMenu/VB/VBStats/GameTimeStat

func _ready() -> void:
	get_tree().paused = false	
	
	
func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("pause"):
		pause_menu.visible=!pause_menu.visible
		get_tree().paused = pause_menu.visible
		if pause_menu.visible : update_stats()

func update_stats():
	asteroids_stat.set_value_label(
		SpaceUtils.get_percentage_string(
			asteroid.asteroid_destroyed,
			asteroid.asteroid_spawned
		)
	)
	
	ships_stat.set_value_label(
		SpaceUtils.get_percentage_string(
			TieFighter.tie_destroyed,
			TieFighter.tie_spawned
		)
	)
	
	game_time_stat.set_value_label(".%2fs" % Player.game_time)
