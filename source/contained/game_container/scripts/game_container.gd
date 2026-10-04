class_name GameContainer extends Node

@export_file("*.tscn") var default_scene_path: String

var contained_scene: Node
var contained_scene_source: PackedScene

func _ready() -> void:
	if not default_scene_path.is_empty():
		load_scene_from_path.call_deferred(default_scene_path)

func load_scene_from_path(path: String) -> void:
	var packed_scene := load(path)
	if packed_scene is PackedScene:
		load_scene(packed_scene)
	else:
		push_error("Attempted to load scene with an invalid type (%s)" % packed_scene)

func load_scene(packed_scene: PackedScene) -> void:
	contained_scene_source = packed_scene
	var scene := packed_scene.instantiate()
	switch_scene(scene)
	
func free_contained_scene() -> void:
	if contained_scene:
		print("Freeing previously contained scene...")
		contained_scene.queue_free()
		contained_scene = null

func switch_scene(scene: Node) -> void:
	free_contained_scene()
	contained_scene = scene
	add_child(scene)
	GameplayEvents.broadcast(&"scene_changed")

func has_contained_scene() -> bool:
	return contained_scene != null

func reload_current_scene() -> void:
	if not contained_scene_source:
		push_error("Attempted to reload scene without source")
		return
	print("Reloading current scene...")
	load_scene(contained_scene_source)
