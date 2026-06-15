extends Area3D

class_name Laser

const OFF_SCREEN: Vector3 = Vector3(0,0,200)

@export var damage: int = 10
@export var speed: float = 80.0

@onready var impact_point: Marker3D = $ImpactPoint
@onready var life_timer: LifeTimer = $LifeTimer

func get_damage() -> int:
	return damage
	
func _ready() -> void:
	stop()
	
func _physics_process(delta: float) -> void:
	translate(Vector3.FORWARD * speed * delta)
	
func start(p_tr: Transform3D) -> void:
	var bas: Basis = p_tr.basis.orthonormalized()
	global_transform = Transform3D(bas, p_tr.origin)

	SpaceUtils.toggle_area3d(self,true)
	set_physics_process(true)
	
	life_timer.start_timer()
	show()

func stop() -> void:
	global_position = OFF_SCREEN
	SpaceUtils.toggle_area3d(self,false)
	hide()
	set_physics_process(false)
	hide()
	

func blow_up() -> void:
	SignalHub.emit_create_one_off(impact_point.global_position, Spawner.SceneNames.ImpactFlash)
	stop()

func _on_area_entered(_area: Area3D) -> void:
	blow_up()

func _on_body_entered(_body: Node3D) -> void:
	blow_up()


func _on_life_timer_time_out() -> void:
	#print("Laser: _on_life_timer_time_out")
	stop()
