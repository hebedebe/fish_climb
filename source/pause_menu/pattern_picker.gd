extends Button

@onready var file_dialog: FileDialog = $FileDialog

func _ready() -> void:
	pressed.connect(on_pressed)
	file_dialog.file_selected.connect(on_file_selected)
	
func on_pressed() -> void:
	file_dialog.popup_file_dialog()

func on_file_selected(path: String) -> void:
	CustomisationManager.player_pattern_path = path
