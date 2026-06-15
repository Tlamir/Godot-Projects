extends HBoxContainer

class_name PauseMenuStat

@export var title: String = "title here"
@export var inital_value: String = " Value here"

@onready var title_label: Label = $Title
@onready var value_label: Label = $Value


func _ready() -> void:
	set_title_label(title)

func set_value_label(v: String):
	value_label.text=v
	
func set_title_label(v: String):
	title_label.text=v
