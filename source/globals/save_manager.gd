extends Node

const SAVE_PATH: String = "user://savegame.save"

var event_listener: EventTrigger

func _ready() -> void:
	event_listener = EventTrigger.new()
	add_child(event_listener)
	event_listener.add_callback(&"save_game", "save_game")
	event_listener.add_callback(&"load_game", "load_game")
	
	print("Save manager initialised")

func save_game() -> void:
	print("Starting DOT save")
	DOT_save.save_data(0.1)
	
func load_game() -> void:
	print("Starting DOT load")
	DOT_save.load_data()
