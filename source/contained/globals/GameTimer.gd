extends Node

var timer: float = 0
var timer_running: bool = true

var broadcast_notify: EventTrigger
var saver: SaverNode

func _ready() -> void:
	broadcast_notify = EventTrigger.new()
	add_child(broadcast_notify)
	broadcast_notify.add_callback(&"pause_timer", pause_timer)
	broadcast_notify.add_callback(&"save_reset", reset_timer)
	
	#SaveManager.bind_save_function(save_timer)
	#SaveManager.bind_load_function(load_timer)
	saver = SaverNode.new()
	add_child(saver)
	saver.add_property("timer")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not timer_running:
		return
	timer += delta

func get_formatted_time() -> String:
	return Utilities.format_time(timer)

func pause_timer() -> void:
	timer_running = false

func reset_timer() -> void:
	timer = 0
