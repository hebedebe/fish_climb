class_name WaterRect extends ColorRect


func _ready() -> void:
	SettingsManager.graphics_settings_changed.connect(on_graphics_settings_changed)
	on_graphics_settings_changed()

func on_graphics_settings_changed() -> void:
	match SettingsManager.water_quality_level:
		SettingsManager.QualityLevel.LOW:
			visible = false
			use_parent_material = true
			return
		SettingsManager.QualityLevel.MEDIUM:
			visible = true
			use_parent_material = true
			self_modulate = Color(0.226, 0.451, 1.0, 0.4)
			return
		SettingsManager.QualityLevel.HIGH:
			visible = true
			use_parent_material = false
			self_modulate = Color.WHITE
			return
