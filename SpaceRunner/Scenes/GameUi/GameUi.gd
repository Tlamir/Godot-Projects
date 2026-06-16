extends Control


class_name GameUi

static var score: int =0:
	set(v):
		score = v
		score = max(v,0)
		SignalHub.emit_score_changed()

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
	asteroid.asteroid_destroyed=0
	asteroid.asteroid_spawned=0
	TieFighter.tie_destroyed=0
	TieFighter.tie_spawned=0
	score = 0
	get_tree().paused = false
	SignalHub.on_player_died.connect(player_died)
	SignalHub.on_score_changed.connect(on_score_changed)
	
func _unhandled_input(event: InputEvent) -> void:
	
	if !game_over.visible and event.is_action_pressed("pause"):
		pause_menu.visible=!pause_menu.visible
		get_tree().paused = pause_menu.visible
		if pause_menu.visible : update_stats()
	elif game_over.visible and event.is_action_pressed("shoot"):
		get_tree().reload_current_scene()

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
	
func player_died():
	game_over_scored.text = "You Score %d points! " %score
	game_over.show()
	get_tree().paused=true
	
func on_score_changed():
	score_label.text = "%6d" % score
