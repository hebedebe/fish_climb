@tool
class_name InstanceCurve
extends Path2D

@export var scene: PackedScene:
	set(value):
		scene = value
		if Engine.is_editor_hint():
			rebuild_path()

@export var bake_interval: float = 300.0:
	set(value):
		bake_interval = value
		if Engine.is_editor_hint():
			rebuild_path()

var instances: Array[InteractiveGrass]

func _ready() -> void:
	rebuild_path()
	if Engine.is_editor_hint():
		curve.changed.connect(rebuild_path)

func rebuild_path() -> void:
	clear_instances()
	
	if bake_interval != curve.bake_interval:
		curve.bake_interval = bake_interval
	
	var points := curve.get_baked_points()
	
	for point in points:
		var instance: Node2D = scene.instantiate()
		add_child(instance)
		instance.transform = curve.sample_baked_with_rotation(curve.get_closest_offset(point))
		instances.append(instance)
	
func clear_instances() -> void:
	if instances.is_empty():
		return
	for instance in instances:
		instance.free()
	instances.clear()
