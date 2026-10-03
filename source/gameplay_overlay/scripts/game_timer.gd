extends Label

func _ready() -> void:
	SettingsManager.gameplay_settings_changed.connect(on_settings_changed)

func _process(_delta: float) -> void:
	text = GameTimer.get_formatted_time()

func on_settings_changed() -> void:
	visible = SettingsManager.show_timer
