extends Node

signal graphics_settings_changed
signal gameplay_settings_changed

enum QualityLevel {
	LOW=0,
	MEDIUM=1,
	HIGH=2,
}

var grass_quality_level: QualityLevel = QualityLevel.HIGH
var water_quality_level: QualityLevel = QualityLevel.HIGH

var show_timer: bool = true

var saver_node: SaverNode

func _ready() -> void:
	saver_node = SaverNode.new()
	add_child(saver_node)
	saver_node.save_mode = SaveManager.SaveMode.Settings
	saver_node.add_property(&"grass_quality_level")
	saver_node.add_property(&"water_quality_level")
	saver_node.add_property(&"show_timer")

func set_setting(property, value):
	set(property, value)
	graphics_settings_changed.emit()

func set_gameplay_setting(property, value):
	set(property, value)
	gameplay_settings_changed.emit()
