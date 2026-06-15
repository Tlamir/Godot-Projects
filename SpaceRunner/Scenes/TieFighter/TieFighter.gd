extends Node3D

class_name TieFighter

@export var stay_still : bool = false
@export var enemy_behaviour: EnemyBehaviour
@export var burst_delay : float = 0.25
@export var burst_amount : int = 3

@onready var engine_sound: AudioStreamPlayer3D = $EngineSound
@onready var player_ref: LinkPlayer = $PlayerRef
@onready var gun: Gun = $Pivot/Gun
@onready var mesh_tie_fighter: MeshInstance3D = $Pivot/TieFighter


const TIE_JUST_FLY = preload("res://Resources/TieJustFly.tres")
const TIE_LOSS_OF_CONTROL = preload("res://Resources/TieLossOfControl.tres")
const TIE_TURN_SHOOT = preload("res://Resources/TieTurnShoot.tres")


func _ready() -> void:
	choose_random_behaviour()
	#enemy_behaviour.setup(self)
	call_deferred("_face_player")

func _physics_process(_delta: float) -> void:
	if !stay_still and enemy_behaviour: 
		enemy_behaviour.update(_delta)
		
func _face_player() -> void:
	if player_ref.player_z > global_position.z :
		rotation.y=PI
	else:
		rotation=Vector3.ZERO
		
func shoot_burst():
	for i in range(burst_amount):
		gun.shoot()
		await get_tree().create_timer(burst_delay).timeout

func _on_hitbox_died() -> void:
	queue_free()
	
func choose_random_behaviour() -> void:	
	var r: float = randf()
	if r < 0.20:
		enemy_behaviour = TIE_LOSS_OF_CONTROL.duplicate(true)
	elif r < 0.8:
		enemy_behaviour = TIE_TURN_SHOOT.duplicate(true)
	else:
		enemy_behaviour = TIE_JUST_FLY.duplicate(true)

	enemy_behaviour.setup(self)
