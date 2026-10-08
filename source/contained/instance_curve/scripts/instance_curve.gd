@tool
class_name InstanceCurve
extends BoundedPath2D

@warning_ignore("unused_private_class_variable")
@export_tool_button("Update Node Location") var _update_node_location_action = update_node_location

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

var instances: Array[Node]

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
		add_child(instance, false, INTERNAL_MODE_BACK)
		instance.transform = curve.sample_baked_with_rotation(curve.get_closest_offset(point))
		instances.append(instance)
	
func clear_instances() -> void:
	if instances.is_empty():
		return
	for instance in instances:
		instance.free()
	instances.clear()


func get_rect() -> Rect2:
	var rect := super.get_rect()
	
	var top_left: Vector2 = rect.position
	var bottom_right: Vector2 = rect.end
	
	for instance: Node2D in instances:
		if instance.has_method("get_rect"):
			var inst_rect: Rect2 = instance.get_rect()
			var relative_position := instance.position + inst_rect.position
			var relative_end := relative_position + inst_rect.size
			top_left.x = min(top_left.x, relative_position.x)
			top_left.y = min(top_left.y, relative_position.y)
			bottom_right.x = max(bottom_right.x, relative_end.x)
			bottom_right.y = max(bottom_right.y, relative_end.y)
	
	rect.position = top_left
	rect.size = bottom_right - top_left
	
	return rect
