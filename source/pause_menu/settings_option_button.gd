@tool
extends OptionButton

@export var target_setting: StringName

func _ready() -> void:
	selected = SettingsManager.get(target_setting)
	setting_updated(selected)
	
	if not Engine.is_editor_hint():
		item_selected.connect(setting_updated)

func setting_updated(value) -> void:
	print("Set setting %s to %s" % [target_setting, value])
	SettingsManager.set(target_setting, value)
