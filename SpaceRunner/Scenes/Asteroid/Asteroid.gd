extends Node3D

class_name asteroid

const EXPLODE_Z: float = -15.0

@export var spin_speed: float = 10
@export var speed: float = -10


@onready var hitbox: HitBox = $Hitbox
@onready var mesh_asteroid: MeshInstance3D = $MeshAsteroid


func _physics_process(delta: float) -> void:	
	if global_position.z > EXPLODE_Z:
		hitbox.blow_up()
		queue_free()
	else:	
		mesh_asteroid.rotate_y(spin_speed * delta)
		mesh_asteroid.rotate_x(spin_speed * delta)
		translate_object_local(Vector3.FORWARD * speed * delta)


func _on_hitbox_died() -> void:
	queue_free()
