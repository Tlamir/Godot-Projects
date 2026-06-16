extends Area3D

class_name Shield


@export var start_health: int = 10

@onready var timer: Timer = $Timer
@onready var shield: Shield = $"."

var _health: int = 0

func _ready() -> void:
	disable_shield()
	pass

func disable_shield() -> void:
	timer.stop()
	SpaceUtils.toggle_area3d(self,false)
	hide()
	# hide
	pass

func enable_shield() -> void:
	_health=start_health
	SpaceUtils.toggle_area3d(self,true)
	timer.start()
	show()
	pass
	
func take_hit() -> void:
	_health-=1
	if _health <=0:
		disable_shield()
	pass

func _on_timer_timeout() -> void:
	disable_shield()
	
func _on_area_entered(area: Area3D) -> void:
	if area is Laser:
		take_hit()


func _on_body_entered(body: Node3D) -> void:
	take_hit()
	body.call_deferred("queue_free")
