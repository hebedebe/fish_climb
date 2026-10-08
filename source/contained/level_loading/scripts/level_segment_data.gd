@tool
class_name LevelSegmentData extends Resource

@export_file_path("*.tscn") var packed_scene_path: String

func has_scene_path() -> bool:
	return not packed_scene_path.is_empty()

func load_scene() -> PackedScene:
	assert(has_scene_path(), "Cannot load from empty path")
	return load(packed_scene_path)
