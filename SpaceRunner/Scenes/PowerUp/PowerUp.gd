extends Area3D

class_name PowerUP


enum PowerUpType { Health, Shield }

const PowerUpMaterial: Dictionary[PowerUpType, ShaderMaterial] = {
	PowerUpType.Health: preload("res://Scenes/PowerUp/PowerUpHealthMaterial.tres"),
	PowerUpType.Shield: preload("res://Scenes/PowerUp/PowerUpShieldMateria.tres")
}

const SPEED: float = 15.0

@onready var power_up_mesh: MeshInstance3D = $PowerUpMesh
@onready var sound: AudioStreamPlayer3D = $Sound

var powerup_type: PowerUpType = PowerUpType.Health:
	get: return powerup_type

func _ready() -> void:
	if randf() > 0.5: powerup_type = PowerUpType.Shield
	power_up_mesh.material_override = PowerUpMaterial[powerup_type]
	

func _physics_process(delta: float) -> void:
	translate(Vector3.BACK * SPEED * delta)


func _on_area_entered(_area: Area3D) -> void:
	SpaceUtils.toggle_area3d(self, false)
	sound.play()
	hide()
	await sound.finished
	queue_free()
