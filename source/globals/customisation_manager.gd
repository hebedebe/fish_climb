extends Node

signal customisation_updated

var player_base_tint: Color = Color.WHITE:
	set(value):
		player_base_tint = value
		customisation_updated.emit()
		
var player_pattern_tint: Color = Color.WHITE:
	set(value):
		player_pattern_tint = value
		customisation_updated.emit()
		
var player_pattern_path: String:
	set(value):
		player_pattern_path = value
		customisation_updated.emit()

var player_pattern_strength: float:
	set(value):
		player_pattern_strength = value
		customisation_updated.emit()


var saver: SaverNode

func _ready() -> void:
	saver = SaverNode.new()
	add_child(saver)
	saver.save_mode = SaveManager.SaveMode.Settings
	saver.add_property("player_base_tint")
	saver.add_property("player_pattern_tint")
	saver.add_property("player_pattern_path")
	saver.add_property("player_pattern_strength")
