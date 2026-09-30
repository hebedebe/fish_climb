extends CheckBox


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	on_pressed()
	pressed.connect(on_pressed)
	
func on_pressed() -> void:
	SettingsManager.set_gameplay_setting("show_timer", button_pressed)
