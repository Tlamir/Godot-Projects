extends Node3D


class_name Spawner


@export var x_range: Vector2 = Vector2(-19, 15)
@export var y_range: Vector2 = Vector2(-16, 18)
@export var enabled: bool = true

@onready var tie_timer: Timer = $TieTimer
@onready var asteroid_timer: Timer = $AsteroidTimer

var _playerLaserPool: LaserPool
var _TieLaserPool: LaserPool


const IMPACT_FLASH = preload("res://Scenes/Vfx/ImpactFlash/ImpactFlash.tscn")
const PLAYER_LASER = preload("res://Scenes/Laser/PlayerLaser.tscn")
const TIE_LASER = preload("res://Scenes/Laser/TieLaser.tscn")

const TIE_FIGHTER = preload("res://Scenes/TieFighter/TieFighter.tscn")
const ASTEROID = preload("res://Scenes/Asteroid/Asteroid.tscn")
const POWER_UP = preload("res://Scenes/PowerUp/PowerUp.tscn")




enum SceneNames { ImpactFlash }
enum LaserTypes { PlayerLaser , TieLaser }

const SCENES_DICT: Dictionary[int,PackedScene] = {
	SceneNames.ImpactFlash: IMPACT_FLASH
}

func _ready() -> void:
	_playerLaserPool = LaserPool.new(10,PLAYER_LASER,self,"PlayerLaser_")
	_TieLaserPool = LaserPool.new(10,TIE_LASER,self,"TieLaser_")
	SignalHub.on_create_one_off.connect(on_create_one_off)
	SignalHub.on_create_laser.connect(on_create_laser)
	SignalHub.on_create_packed_scene.connect(on_create_packed_scene)
	SignalHub.on_create_power_up.connect(on_create_power_up)
	

func on_create_laser(p_tr: Transform3D, laser_type: Spawner.LaserTypes ):
	match  laser_type:
		
		LaserTypes.PlayerLaser: 
			_playerLaserPool.activate_next_scene(p_tr)
			
		LaserTypes.TieLaser:	
			_TieLaserPool.activate_next_scene(p_tr)

func add_with_transform(ob: Node3D, p_tr: Transform3D) -> void:
	ob.transform = p_tr  # set BEFORE adding to tree
	add_child(ob)
	ob.global_transform = p_tr  # correct to global after


func add_with_position(ob: Node3D, p_pos: Vector3) -> void:
	add_child(ob)
	ob.global_position = p_pos


func on_create_packed_scene(p_tr: Transform3D, ps: PackedScene) -> void:
	var ns = ps.instantiate()
	call_deferred("add_with_transform", ns, p_tr)

func on_create_one_off(p_pos: Vector3, scene_name: Spawner.SceneNames) -> void:
	if !SCENES_DICT.has(scene_name): return
	var ns = SCENES_DICT[scene_name].instantiate()
	call_deferred("add_with_position",ns,p_pos)
		
func spawn_enemies(scene: PackedScene, 
				wait_time: float,  
				spawn_range_x: Vector2, 
				spawn_range_y: Vector2, 
				count_range: Vector2i, 
				timer: Timer) -> void:
	if !enabled: return
	
	var rand_x: float = randf_range(spawn_range_x.x, spawn_range_x.y)
	var rand_y: float = randf_range(spawn_range_y.x, spawn_range_y.y)
	var np: Vector3 = Vector3(rand_x, rand_y, global_position.z)
	
	for i in randi_range(count_range.x, count_range.y):
		var enemy: Node3D = scene.instantiate()
		add_child(enemy)
		enemy.global_position = np 
		await get_tree().create_timer(wait_time, false, true).timeout
		
	timer.start()

func _on_tie_timer_timeout() -> void:
		spawn_enemies(TIE_FIGHTER, 1.5, x_range, y_range, Vector2i(1,3), tie_timer) 

func _on_asteroid_timer_timeout() -> void:
		spawn_enemies(ASTEROID, 2.5, x_range, y_range, Vector2i(1,3), asteroid_timer) 
		pass
		
func on_create_power_up(p_pos: Vector3) -> void:
	var npu: PowerUP = POWER_UP.instantiate()
	call_deferred("add_with_position", npu, p_pos)
