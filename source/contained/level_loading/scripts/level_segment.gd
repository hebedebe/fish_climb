@tool
@icon("res://addons/at-icons/node2d/jigsaw_piece.svg")
class_name LevelSegment extends VisibleOnScreenNotifier2D

const SAVE_PATH = "res://data/level_segments/"

#@export_group("Tool Buttons")
#@export_tool_button("Pack contained scene") var pack_action = pack_contents
#@export_tool_button("Unpack contained scene") var unpack_action = unpack_contents
#@export_tool_button("Generate bounds") var generate_bounds_action = update_rect
#@export_tool_button("Update child nodes") var update_child_nodes_action := update_contained_scene_node

@export_group("Data")
@export var segment_data: LevelSegmentData: 
	get:
		if segment_data == null and Engine.is_editor_hint():
			segment_data = LevelSegmentData.new()
		return segment_data

@export_group("Loading")
@export var padding: float = 10

var contained_scene_node: Node

func _ready() -> void:
	if not Engine.is_editor_hint():
		assert(segment_data, "Level segment has no segment data.")
		update_contained_scene_node()
		update_rect()
		if contained_scene_node and not is_on_screen():
			print("collapsing off-screen scene node at ready time")
			pack_contents()
			clear_contents()
		screen_entered.connect(unpack_contents)
		screen_exited.connect(clear_contents)

func clear_contents() -> void:
	contained_scene_node.queue_free()
	contained_scene_node = null

func update_contained_scene_node() -> void:
	var child_count := get_child_count()
	if child_count == 0:
		contained_scene_node = null
		return
	
	if get_child_count() > 1: # we have more than one viable root node
		contained_scene_node = Node2D.new() # create a new root node
		add_child(contained_scene_node)
		contained_scene_node.owner = get_tree().edited_scene_root
		contained_scene_node.name = "RootContainer(automatic)"
		for child in get_children():
			if child == contained_scene_node: continue
			child.reparent(contained_scene_node) # make them all children of the new root
		print("Updated level segment root node")
	else:
		contained_scene_node = get_child(0)

func get_id():
	assert(not segment_data.resource_scene_unique_id.is_empty(), "Segment data has no unique id.")
	return segment_data.resource_scene_unique_id

func generate_packed_scene() -> PackedScene:
	assert(contained_scene_node, "Contained scene node is invalid")
	
	for child in contained_scene_node.get_children():
		print("found child ", child)
		Utilities.set_owner_recursive(child, contained_scene_node)
	
	var packed_scene := PackedScene.new()
	var result = packed_scene.pack(contained_scene_node)
	if result != OK:
		push_error("An error occured while generating packed scene: ", result)
	
	return packed_scene

func unpack_contents() -> void:
	assert(contained_scene_node == null, "Cannot unpack while node has children.")
	assert(segment_data.has_scene_path(), "Cannot unpack empty scene")
	var packed_scene := segment_data.load_scene()
	packed_scene.resource_local_to_scene = true
	var node := packed_scene.instantiate(PackedScene.GEN_EDIT_STATE_DISABLED)
	add_child(node)
	update_contained_scene_node()
	if Engine.is_editor_hint():
		contained_scene_node.owner = get_tree().edited_scene_root

func get_save_path() -> String:
	return SAVE_PATH+get_id()+".tscn"

func pack_contents() -> void:
	update_contained_scene_node()
	update_rect()
	var packed_scene := generate_packed_scene()
	if packed_scene:
		var path := save_packed_scene(packed_scene)
		if not path.is_empty():
			segment_data.packed_scene_path = path
			#contained_scene_node.queue_free() # nodes are now in the filesystem
		else:
			if Engine.is_editor_hint(): #undo owner setting
				Utilities.set_owner_recursive(contained_scene_node, get_tree().edited_scene_root)

## Returns the save path, or an empty string if saving fails
func save_packed_scene(packed_scene: PackedScene) -> String:
	var path := get_save_path()
	print("Saving level segment packed scene to path ", path)
	var error = ResourceSaver.save(packed_scene, path)
	if error != OK:
		push_error("An error occurred while saving the scene to disk")
		return ""
	return path

func update_rect() -> void:
	#update_contained_scene_node()
	var top_left_corner: Vector2 = global_position
	var bottom_right_corner: Vector2 = global_position
	for child in Utilities.get_children_recursive(self):
		if child.has_method("get_rect"):
			var child_rect: Rect2 = child.get_rect()
			var rect_position = child.global_position + child_rect.position
			var rect_end = child.global_position + child_rect.end
			top_left_corner.x = min(rect_position.x, top_left_corner.x)
			top_left_corner.y = min(rect_position.y, top_left_corner.y)
			bottom_right_corner.x = max(rect_end.x, bottom_right_corner.x)
			bottom_right_corner.y = max(rect_end.y, bottom_right_corner.y)
	rect.position = top_left_corner - global_position
	rect.size = bottom_right_corner - top_left_corner
	rect = rect.grow(padding)
