@tool
@icon("res://addons/at-icons/node2d/grass.svg")
## Instance curve with defaults
class_name GrassCurve extends InstanceCurve


func _ready() -> void:
	super._ready()
	scene = preload("uid://qm3jgcscb63x")
