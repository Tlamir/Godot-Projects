extends Camera3D


@export var camera_follow_speed: Vector2 = Vector2(18.0, 32.0) 
@export var offset: Vector3 = Vector3(0, 6, 15) 
@export var shake_amount: float = 0.1
@export var shake_time: float = 0.15


var shake_timer: float = 0.0

@onready var player_ref: LinkPlayer = $PlayerRef

func _ready() -> void:
	SignalHub.on_player_hit.connect(on_player_hit)


func _physics_process(delta: float) -> void:
	var target_position = player_ref.player_pos + offset
	
	
	var x_delta: float = abs(target_position.x - global_position.x)
	var y_delta: float = abs(target_position.y - global_position.y)
	var speed = camera_follow_speed.x if x_delta > y_delta else camera_follow_speed.y
	global_position = global_position.move_toward(target_position, speed * delta)
	camera_shake(delta)
	
	
func on_player_hit():
	shake_timer = shake_time
	
func camera_shake(_delta: float):
	if shake_timer > 0:
		global_position += Vector3(
			randf_range(-shake_amount, shake_amount),
			randf_range(-shake_amount, shake_amount),
			randf_range(-shake_amount, shake_amount)
		)
		shake_timer -= _delta
