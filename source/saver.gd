@icon("res://addons/at-icons/node/floppy_disk.svg")
class_name Saver extends Node

enum SaveName {
	OwnerName,
	OwnerPath,
	SaverName,
	SaverPath
}

@export var save_name_mode: SaveName
@export var properties_to_save: Array[StringName]

func _ready() -> void:
	if not owner:
		printerr("Saver must have an owning node")
	
	DOT_save.data_is_saving.connect(save_data)
	DOT_save.data_is_loading.connect(load_data)

func get_save_name() -> String:
	match save_name_mode:
		SaveName.OwnerName:
			return owner.name
		SaveName.OwnerPath:
			return owner.get_path()
		SaveName.SaverName:
			return name
		SaveName.SaverPath:
			return get_path()
	printerr("Could not get save name")
	return ""

func save_path(property_name: String) -> String:
	return get_save_name() + "." + property_name

func save_value(property_name: String) -> void:
	DOT_save.set_value_data(save_path(property_name), owner.get(property_name))
	
func load_value(property_name: String) -> void:
	var value = DOT_save.get_value_data(save_path(property_name))
	if value:
		owner.set(property_name, value)

func save_data() -> void:
	#print("Saving data for ", name)
	for property in properties_to_save:
		save_value(property)
	
func load_data() -> void:
	for property in properties_to_save:
		load_value(property)
