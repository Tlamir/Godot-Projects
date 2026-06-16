extends Node

signal on_create_one_off(p_pos: Vector3, scene_name: Spawner.SceneNames)
signal on_create_laser(p_tr: Transform3D, lazer_type: Spawner.LaserTypes)
signal on_create_packed_scene(p_tr: Transform3D, ps: PackedScene)
signal on_player_died()
	
func emit_create_laser(p_tr: Transform3D, laser_type: Spawner.LaserTypes )  -> void:
	on_create_laser.emit(p_tr, laser_type)

func emit_create_one_off(p_pos: Vector3, scene_name: Spawner.SceneNames) -> void:
	on_create_one_off.emit(p_pos, scene_name)

func emit_create_packed_scene(p_tr: Transform3D, ps: PackedScene) -> void:
	on_create_packed_scene.emit(p_tr,ps)

func emit_player_died():
	on_player_died.emit()
