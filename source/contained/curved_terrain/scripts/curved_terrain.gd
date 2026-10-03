@icon("res://addons/at-icons/node2d/itinerary.svg")
@tool
class_name CurvedTerrain
extends Path2D

@warning_ignore("unused_private_class_variable")
@export_tool_button("Update Node Location") var _update_node_location_action = update_node_location

@export_group("Visuals")
@export_subgroup("Edge")
@export var edge_visible: bool = true:
	set(value): 
		edge_visible = value
		update_edge()
@export var edge_texture: Texture2D:
	set(value): 
		edge_texture = value
		update_edge()
@export var edge_width: float = 10.0:
	set(value): 
		edge_width = value
		update_edge()

@export_subgroup("Fill")
@export var fill_visible: bool = true:
	set(value): 
		fill_visible = value
		update_fill()
@export var fill_texture: Texture2D:
	set(value):
		fill_texture = value
		update_fill()

@export_custom(PROPERTY_HINT_LINK, "") var fill_texture_scale := Vector2(1.0, 1.0):
	set(value):
		fill_texture_scale = value
		update_fill()

@export_subgroup("")
@export var material_override: Material:
	set(value):
		material_override = value
		update_fill()
		update_edge()

@export_group("Performance")
@export var generate_collision: bool = true:
	set(value):
		generate_collision = value
		editor_generate_terrain()
		
@export var bake_interval: float = 100.0:
	set(value):
		bake_interval = value
		update_curve()

@export_group("Debug")
@export var visible_collision: bool = true:
	set(value):
			visible_collision = value
			update_collision_visibility()

var polygon2d: Polygon2D
var line2d: Line2D
var collision_polygon2d: CollisionPolygon2D
var static_body: StaticBody2D

func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	
	create_child_nodes()
	_generate_terrain()
	
	curve.changed.connect(editor_generate_terrain)

func create_child_nodes() -> void:
	polygon2d = Polygon2D.new()
	polygon2d.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	add_child(polygon2d)
	
	line2d = Line2D.new()
	line2d.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	line2d.texture_mode = Line2D.LINE_TEXTURE_TILE
	add_child(line2d)
	
	static_body = StaticBody2D.new()
	add_child(static_body)
	collision_polygon2d = CollisionPolygon2D.new()
	static_body.add_child(collision_polygon2d)

func editor_generate_terrain() -> void:
	if not Engine.is_editor_hint():
		return
	_generate_terrain()

func _generate_terrain() -> void:
	if !curve or curve.point_count == 0:
		collision_polygon2d.polygon = []
		polygon2d.polygon = []
		line2d.points = []
		return
		
	update_curve()
	
	var points := curve.get_baked_points()
	var collider_points := curve.get_baked_points()
	
	if points.size() > 1:
		points.append(points[0])
	
	if polygon2d:
		polygon2d.polygon = points
		update_fill()
	
	if line2d:
		line2d.points = points
		update_edge()
	
	if collider_points.size() > 2 and generate_collision:
		collision_polygon2d.polygon = collider_points
	update_collision_visibility()

func update_collision_visibility() -> void:
	if collision_polygon2d:
		collision_polygon2d.visible = visible_collision

func update_fill():
	if polygon2d:
		polygon2d.visible = fill_visible
		polygon2d.texture = fill_texture
		polygon2d.texture_scale = fill_texture_scale
		if material_override:
			polygon2d.material = material_override
		
func update_edge():
	if line2d:
		line2d.visible = edge_visible
		line2d.texture = edge_texture
		line2d.width = edge_width
		line2d.joint_mode = Line2D.LINE_JOINT_SHARP
		#line2d.antialiased = true
		if material_override:
			polygon2d.material = material_override

func update_curve():
	if curve and curve.bake_interval != bake_interval:
		curve.bake_interval = bake_interval

func get_average_point_location() -> Vector2:
	var point_total: Vector2 = Vector2.ZERO
	for idx in curve.point_count:
		point_total += curve.sample(idx, 0)
	var point_average: Vector2 = point_total / curve.point_count
	return point_average

func update_node_location() -> void:
	var points_average := get_average_point_location()
	print(points_average)
	position += points_average
	
	for idx in curve.point_count:
		curve.set_point_position(idx, curve.get_closest_point(curve.sample(idx,0)) - points_average)
	
