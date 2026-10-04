extends Button

const WEB_FILE_PATH = "user://patterns/"

@export var file_types: String

var web_file_dialogue: FileAccessWeb

@onready var file_dialog: FileDialog = $FileDialog

func _ready() -> void:
	pressed.connect(on_pressed)
	
	match OS.get_name():
		"Web":
			web_file_dialogue = FileAccessWeb.new()
			web_file_dialogue.loaded.connect(on_file_selected_web)
		_:
			file_dialog.file_selected.connect(on_file_selected)
	
	
	
func on_pressed() -> void:
	match OS.get_name():
		"Web":
			web_file_dialogue.open(file_types)
		_:
			file_dialog.popup_centered()

func on_file_selected_web(file_name: String, _file_type: String, base64_data: String) -> void:
	var raw_data := Marshalls.base64_to_raw(base64_data)
	
	var file_path := WEB_FILE_PATH + file_name
	DirAccess.make_dir_absolute(WEB_FILE_PATH)
	
	var file := FileAccess.open(file_path, FileAccess.WRITE)
	file.store_buffer(raw_data)
	file.close()
	
	print("(WEB ONLY) Saved file copy to %s (%s bytes)" % [file_path, raw_data.size()])
	if not OS.is_userfs_persistent():
		print("(WEB ONLY) User filesystem is NOT persistent - file copy will be lost on reload")
	
	CustomisationManager.player_pattern_path = file_path

func on_file_selected(path: String) -> void:
	CustomisationManager.player_pattern_path = path
