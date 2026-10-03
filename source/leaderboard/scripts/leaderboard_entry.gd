@tool
class_name LeaderboardEntry extends HBoxContainer

@export var entry_name: String = "Name":
	set(value):
		entry_name = value
		refresh_node_text()

@export var entry_value: String = "Value":
	set(value):
		entry_value = value
		refresh_node_text()

var entry_name_node: Label
var spacer: Control
var entry_value_node: Label

func _ready() -> void:
	entry_name_node = Label.new()
	add_child(entry_name_node)
	entry_name_node.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	
	spacer = Control.new()
	add_child(spacer)
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	entry_value_node = Label.new()
	add_child(entry_value_node)
	entry_value_node.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	
	refresh_node_text()

func refresh_node_text() -> void:
	if entry_value_node:
		entry_value_node.text = entry_value

	if entry_name_node:
		entry_name_node.text = entry_name
