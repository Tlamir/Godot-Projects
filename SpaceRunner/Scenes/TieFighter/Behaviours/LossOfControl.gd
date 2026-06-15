extends EnemyBehaviour

class_name LossOfControl

@export var lost_control_distance: float = 50
@export var lost_control_speed: float = 25
@export var player_reach_distance: float = 10
@export var spin_speed: float =8.0

var _player_pos : Vector3 

const _384472__BROKEN_TIE = preload("res://Assets/Audio/Effects/384472__broken_tie.wav")


var _lost_control: bool = false
var _past_player: bool = false


func setup(p_owner: TieFighter) -> void:
	super(p_owner)
	owner.engine_sound.stream = _384472__BROKEN_TIE

func update(delta: float) -> void:
	if owner == null or owner.player_ref == null: return  
	_player_pos = owner.player_ref.player_pos
	var z_dist: float = abs(_player_pos.z - owner.global_position.z)
	
	if z_dist < player_reach_distance:
		_past_player = true
	
	if !_lost_control and z_dist < lost_control_distance:
		_lost_control = true
		speed = lost_control_speed
		
	if _lost_control:
		if!_past_player:
			owner.look_at(_player_ref.player_pos)
		owner.mesh_tie_fighter.rotate_y(spin_speed*delta)
		owner.mesh_tie_fighter.rotate_z(spin_speed*delta)
		
	super(delta)
		
