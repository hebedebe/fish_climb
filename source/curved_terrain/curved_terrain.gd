@tool
class_name CurvedTerrain
extends Path2D

@export_group("Visuals")
@export var edge_texture: Texture2D:
	set(value): 
		edge_texture = value
		update_edge()
@export var edge_width: float = 10.0:
	set(value): 
		edge_width = value
		update_edge()

@export var fill_texture: Texture2D:
	set(value):
		fill_texture = value
		update_fill()

@export_custom(PROPERTY_HINT_LINK, "") var fill_texture_scale := Vector2(1.0, 1.0):
	set(value):
		fill_texture_scale = value
		update_fill()

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
	
	texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	_generate_terrain()
	
	curve.changed.connect(editor_generate_terrain)
	
	print("Generated curve terrain ", name)

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
		polygon2d.texture = fill_texture
		polygon2d.texture_scale = fill_texture_scale
		if material_override:
			polygon2d.material = material_override
		
func update_edge():
	if line2d:
		line2d.texture = edge_texture
		line2d.width = edge_width
		if material_override:
			polygon2d.material = material_override

func update_curve():
	if curve and curve.bake_interval != bake_interval:
		curve.bake_interval = bake_interval
