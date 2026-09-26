extends Node

const SAVE_PATH: String = "user://savegame.save"

var event_listener: EventTrigger

var auto_load: bool = true

var autosave: bool = true
var autosave_interval: float = 0.5

func _ready() -> void:
	event_listener = EventTrigger.new()
	add_child(event_listener)
	event_listener.add_callback(&"save_game", "save_game")
	event_listener.add_callback(&"load_game", "load_game")
	
	print("Save manager initialised")
	
	if auto_load:
		await get_tree().create_timer(0.2).timeout
		load_game()
	autosave_loop()

func autosave_loop() -> void:
	await get_tree().create_timer(autosave_interval).timeout
	if autosave:
		save_game()
	autosave_loop()

func save_game() -> void:
	#print("Starting DOT save")
	DOT_save.save_data(0.1)
	
func load_game() -> void:
	#print("Starting DOT load")
	DOT_save.load_data()

func clear_save() -> void:
	DOT_save.delete_data()
