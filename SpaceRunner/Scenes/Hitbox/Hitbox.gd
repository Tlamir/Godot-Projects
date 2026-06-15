@tool
extends Area3D

class_name HitBox

signal  died

@export var shape_resource: Shape3D
@export var start_health: int = 100
@export var explosion_scene: PackedScene 
@export var shatter_scene: PackedScene

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

var _current_health: int =0
var _dead: bool = false

func _update_components():
	collision_shape_3d.shape = shape_resource
	
func _notification(what: int) -> void:
	if what == NOTIFICATION_EDITOR_POST_SAVE:
		_update_components()
		
func _ready() -> void:
	_current_health = start_health
	_update_components()
	
func disable() -> void:
	SpaceUtils.toggle_area3d(self,false)
	
func die():
	_dead=true
	died.emit()
	disable()
	
func blow_up():
	if explosion_scene: 
		SignalHub.emit_create_packed_scene(global_transform,explosion_scene)
	if shatter_scene:
		SignalHub.emit_create_packed_scene(global_transform,shatter_scene)

func take_damage(v: int):
	if _dead: return
	_current_health-= v
	if _current_health<=0:
		blow_up()
		die()
		pass

func _on_area_entered(area: Area3D) -> void:
	if area is Laser:
		take_damage(area.get_damage())
