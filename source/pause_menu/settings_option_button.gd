@tool
extends OptionButton

@export var target_setting: StringName:
	set(value):
		target_setting = value
		if SettingsManager.get(target_setting) == null:
			printerr("Not a valid setting")
		else:
			selected = SettingsManager.get(target_setting)

func _ready() -> void:
	selected = SettingsManager.get(target_setting)
	
	if not Engine.is_editor_hint():
		item_selected.connect(setting_updated)

func setting_updated(value) -> void:
	SettingsManager.set(target_setting, value)
