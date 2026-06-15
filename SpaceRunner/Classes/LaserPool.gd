class_name LaserPool

var _scenes_list: Array[Laser]
var _container: Node3D
var _packed_scene: PackedScene
var _name_prefix: String

func _init(start_scenes: int, packed: PackedScene, container:Node3D, name_prefix: String) ->void:
	_container=container
	_name_prefix=name_prefix
	_packed_scene = packed
	for i in range (start_scenes):
		add_new_scene()
	
func add_new_scene() -> Laser:
	var ns: Laser = _packed_scene.instantiate()
	if _name_prefix != "": ns.name = "%s_%d" % [_name_prefix,(_scenes_list.size()+1)]
	_container.add_child(ns)
	_scenes_list.append(ns)
	#print("add_new_scene ", ns.name, " now size: ", _scenes_list.size())
	return ns

func activate_next_scene(p_tr: Transform3D) -> void:
	for i in range(_scenes_list.size()):
		var scene: Laser = _scenes_list[i]
		if !scene.visible:
			scene.start(p_tr)
			#print("re-using ", scene.name)
			return
	var ns: Laser = add_new_scene()
	ns.start(p_tr)
			
