extends Node

const BASE_SAVE_PATH = "user://"

enum SaveMode {
	Game,
	Settings,
}

signal saving(mode: SaveMode)
signal loading(mode: SaveMode)

var event_listener: EventTrigger

var auto_load: bool = true

var autosave: bool = true
var autosave_interval: float = 0.5

var save_data: Dictionary

func _ready() -> void:
	event_listener = EventTrigger.new()
	add_child(event_listener)
	event_listener.add_callback(&"save_game", "save_game")
	event_listener.add_callback(&"load_game", "load_game")
	
	print("Save manager initialised")
	
	
	if auto_load:
		get_tree().scene_changed.connect(load_save)
		await load_save()
	autosave_loop()

func load_save():
	call_deferred("load_game", SaveMode.Game)
	call_deferred("load_game", SaveMode.Settings)

func autosave_loop() -> void:
	await get_tree().create_timer(autosave_interval).timeout
	if autosave:
		save_game(SaveMode.Game)
		save_game(SaveMode.Settings)
	autosave_loop()

func save_game(mode: SaveMode, emit: bool = true) -> void:
	#check_saver_paths()
	if emit:
		saving.emit(mode)
	#print(get_save_path(mode))
	var file := FileAccess.open(get_save_path(mode), FileAccess.WRITE)
	ensure_save_entry(mode)
	var data := var_to_bytes(save_data[mode]).compress(FileAccess.CompressionMode.COMPRESSION_GZIP)
	#data = data.remove_char(" ".unicode_at(0))#.strip_edges().strip_escapes()
	if data:
		file.store_buffer(data)
		file.close()

func load_game(mode: SaveMode, emit: bool = true) -> void:
	if not FileAccess.file_exists(get_save_path(mode)):
		push_error("Cannot load from nonexistent file.")
		return
	var file_contents := Utilities.get_byte_file_content(get_save_path(mode))
	var data = bytes_to_var(file_contents.decompress_dynamic(-1, FileAccess.CompressionMode.COMPRESSION_GZIP))
	save_data[mode] = data
	if emit:
		loading.emit(mode)

func clear_data(mode: SaveMode):
	save_data[mode] = {}
	save_game(mode, false)
	load_game(mode)

func get_save_path(mode: SaveMode) -> String:
	return BASE_SAVE_PATH + "%s.save" % mode

func ensure_save_entry(mode: SaveMode):
	if not save_data.has(mode):
		save_data[mode] = {}

func store_value(mode: SaveMode, property_key, property_value) -> void:
	ensure_save_entry(mode)
	save_data[mode][property_key] = var_to_bytes(property_value)

func get_value(mode: SaveMode, property_key) -> Variant:
	ensure_save_entry(mode)
	if save_data[mode].has(property_key):
		return bytes_to_var(save_data[mode][property_key])
	else:
		return null

## checks that there are no conflicting saver paths
func check_saver_paths() -> void:
	var savers := get_tree().get_nodes_in_group(&"Saver")
	var paths: Array
	for saver: SaverNode in savers:
		paths.append_array(saver.get_all_save_paths())
	var check_successful: bool = true
	for path in paths:
		var path_count = paths.count(path)
		if path_count > 1:
			push_error("Found duplicated path \"%s\" (%s uses)" % [path, path_count])
			check_successful = false
	if check_successful:
		print("Check passed!")
	else:
		print("Check failed")
