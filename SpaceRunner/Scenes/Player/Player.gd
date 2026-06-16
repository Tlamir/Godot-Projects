extends CharacterBody3D


class_name Player


const GROUP_PLAYER: String = "player"
@export var  debrie_dmg: float = 10

static var game_time: float = 0


@export var fly_speed: float = 30.0
@export var roll_speed: float = 25.0
@export var tilt_speed: float = 20.0
@export var max_tilt_angle: float = 20.0
@export var max_roll_angle: float = 30.0
@export var health_bonus: int = 10

@onready var pivot: Node3D = $Pivot
@onready var gun: Gun = $Pivot/Gun
@onready var impact_flash: ImpactFlash = $ImpactFlash
@onready var health_bar: HealthBar = $UI/HealthBar
@onready var shield: Shield = $Shield


func _enter_tree() -> void:
	game_time =0
	add_to_group(GROUP_PLAYER)

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

func debrie_hit():
	#impact_flash.bang()
	health_bar.take_damage(debrie_dmg)
		

func _on_hit_area_body_entered(_body: Node3D) -> void:
	debrie_hit()
	

func _on_hit_area_area_entered(_area: Area3D) -> void:
	if _area is Laser:
		health_bar.take_damage(_area.get_damage())
		SignalHub.emit_player_hit()
	elif _area is HitBox:
		debrie_hit()
	elif _area is PowerUP:
		match _area.powerup_type:
			PowerUP.PowerUpType.Health:
				health_bar.incr_value(health_bonus)
			PowerUP.PowerUpType.Shield:
				shield.enable_shield()

func _on_health_bar_died() -> void:
	set_physics_process(false)
	SignalHub.emit_player_died()
