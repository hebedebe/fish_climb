extends Node

signal graphics_settings_changed
signal gameplay_settings_changed

enum QualityLevel {
	LOW,
	MEDIUM,
	HIGH,
}

var grass_quality_level: QualityLevel = QualityLevel.HIGH
var water_quality_level: QualityLevel = QualityLevel.HIGH

var show_timer: bool = true

func set_setting(property, value):
	set(property, value)
	graphics_settings_changed.emit()

func set_gameplay_setting(property, value):
	set(property, value)
	gameplay_settings_changed.emit()
