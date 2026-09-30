extends Node

signal graphics_settings_changed

enum QualityLevel {
	LOW,
	MEDIUM,
	HIGH,
}

var grass_quality_level: QualityLevel = QualityLevel.HIGH
var water_quality_level: QualityLevel = QualityLevel.HIGH


func set_setting(property, value):
	set(property, value)
	graphics_settings_changed.emit()
