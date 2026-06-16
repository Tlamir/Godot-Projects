extends CharacterBody3D


class_name Player


const GROUP_PLAYER: String = "player"

static var game_time: float = 0


@export var fly_speed: float = 30.0
@export var roll_speed: float = 25.0
@export var tilt_speed: float = 20.0
@export var max_tilt_angle: float = 20.0
@export var max_roll_angle: float = 30.0


@onready var pivot: Node3D = $Pivot
@onready var gun: Gun = $Pivot/Gun
@onready var impact_flash: ImpactFlash = $ImpactFlash

func _physics_process(delta: float) -> void:
	
	var pitch_input = Input.get_axis("pitch_down", "pitch_up")
	var roll_input = Input.get_axis("roll_left", "roll_right")

	velocity.y = pitch_input * fly_speed
	velocity.x = roll_input * fly_speed	
	
	move_and_slide()
	update_ship_rotation(roll_input, pitch_input, delta)
	
	if Input.is_action_pressed("shoot"):
		shoot()
	game_time+=delta


func update_ship_rotation(roll_input: float, pitch_input: float, delta: float) -> void:
	var target_roll = -roll_input * max_roll_angle  
	var target_pitch = pitch_input * max_tilt_angle
	pivot.rotation_degrees.x = lerp(pivot.rotation_degrees.x, target_pitch, delta * tilt_speed)
	pivot.rotation_degrees.z = lerp(pivot.rotation_degrees.z, target_roll, delta * roll_speed)
	
	
func shoot() -> void:
	gun.shoot()



func _on_hit_area_body_entered(body: Node3D) -> void:
	impact_flash.bang()


func _on_hit_area_area_entered(area: Area3D) -> void:
	if area is Laser:
		pass
	elif area is HitBox:
		impact_flash.bang()
