extends OptionButton

@export var target_setting: StringName

func _ready() -> void:
	item_selected.connect(setting_updated)
	refresh_selection()

func setting_updated(value) -> void:
	print("Set setting %s to %s" % [target_setting, value])
	SettingsManager.set_setting(target_setting, value)

func refresh_selection() -> void:
	selected = SettingsManager.get(target_setting)
