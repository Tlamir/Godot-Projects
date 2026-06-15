extends Node

const IMPACT_FLASH = preload("res://Scenes/Vfx/ImpactFlash/ImpactFlash.tscn")

@onready var world_environment: WorldEnvironment = $WorldEnvironment

@export var sky_rotation_speed: float = -0.008
@export var sky_rotation_direction: Vector3 = Vector3.UP:
	set(value):
		sky_rotation_direction = value.normalized()

func _physics_process(delta: float) -> void:
	_rotate_sky(delta)

func _rotate_sky(delta: float) -> void:
	if world_environment == null:
		return

	var env := world_environment.environment
	if env == null:
		return

	env.sky_rotation += sky_rotation_direction * sky_rotation_speed * delta


func _on_test_timer_timeout() -> void:
	pass
