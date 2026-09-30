extends Node

signal graphics_settings_changed

enum QualityLevel {
	LOW,
	MEDIUM,
	HIGH
}

var grass_quality_level: QualityLevel = QualityLevel.HIGH:
	set(value):
		grass_quality_level = value
		graphics_settings_changed.emit()


var water_quality_level: QualityLevel = QualityLevel.HIGH:
	set(value):
		water_quality_level = value
		graphics_settings_changed.emit()


var saver: SaverNode

func _ready() -> void:
	saver = SaverNode.new()
	add_child(saver)
	saver.add_property("water_quality_level")
