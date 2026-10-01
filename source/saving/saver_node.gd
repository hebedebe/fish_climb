@tool
@icon("res://addons/at-icons/node/floppy_disk.svg")
class_name SaverNode extends Node

signal data_loaded
signal data_saved

enum SaveName {
	ParentName,
	ParentPath,
	SaverName,
	SaverPath,
	Custom,
}

@export_group("Save Settings")

@export var save_enabled: bool = true
@export var load_enabled: bool = true

@export var save_mode: SaveManager.SaveMode

@export var hash_save_name: bool = true

@export var save_name_mode: SaveName:
	get:
		if custom_save_name.is_empty():
			if save_name_mode == SaveName.Custom:
				save_name_mode = SaveName.ParentName
			return save_name_mode
		else:
			return SaveName.Custom

@export var custom_save_name: StringName ##a custom path to save the data to - setting this will override save_name_mode
@export var properties_to_save: Array[StringName]

@export_group("Debugging")
@export var print_on_save: bool = false
@export var print_on_load: bool = false

func _ready() -> void:
	if not get_parent():
		printerr("Saver (%s) must have an owning node" % name)
	
	if not Engine.is_editor_hint():
		SaveManager.saving.connect(save_data)
		SaveManager.loading.connect(load_data)

func get_save_name() -> String:
	var save_name: String = ""
	match save_name_mode:
		SaveName.ParentName:
			save_name = get_parent().name
		SaveName.ParentPath:
			save_name = get_parent().get_path()
		SaveName.SaverName:
			save_name = name
		SaveName.SaverPath:
			save_name = get_path()
		SaveName.Custom:
			save_name = custom_save_name
	
	return save_name

func get_save_path(property_name: String) -> String:
	var save_path = Utilities.dot_separated_string(get_save_name(), property_name)
	if hash_save_name:
		save_path = Utilities.small_hash(save_path)
	return save_path

func save_value(property_name: String) -> void:
	var path = get_save_path(property_name)
	if print_on_load:
		print("Saving data to ", path)
	SaveManager.store_value(save_mode, path, get_parent().get(property_name))
	
func load_value(property_name: String) -> void:
	var path = get_save_path(property_name)
	if print_on_load:
		print("Loading data from ", path)
	var value = SaveManager.get_value(save_mode, path)
	if value:
		get_parent().set(property_name, value)

func save_data(mode: SaveManager.SaveMode) -> void:
	if not save_enabled:
		return
	if not mode == save_mode:
		return
	for property in properties_to_save:
		save_value(property)
	data_saved.emit()
	
func load_data(mode: SaveManager.SaveMode) -> void:
	if not load_enabled:
		return
	if not mode == save_mode:
		return
	for property in properties_to_save:
		load_value(property)
	data_loaded.emit()

func add_property(property: StringName) -> void:
	if not property in properties_to_save:
		properties_to_save.append(property)
