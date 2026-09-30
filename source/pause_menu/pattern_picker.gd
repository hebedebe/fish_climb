extends Button

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

func on_file_selected_web(file_name: String, _file_type: String, _base64_data: String) -> void:
	CustomisationManager.player_pattern_path = file_name

func on_file_selected(path: String) -> void:
	CustomisationManager.player_pattern_path = path
