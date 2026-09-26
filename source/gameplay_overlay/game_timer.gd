extends Label


var timer: float

func _ready() -> void:
	SaveManager.bind_save_function(save_timer)
	SaveManager.bind_load_function(load_timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	var minutes = floor(timer / 60.0)
	var seconds = floori(timer) % 60
	var milliseconds = timer - floor(timer)
	text = "%02d:%02d.%0d" % [minutes, seconds, milliseconds*1000]

func save_timer() -> void:
	DOT_save.set_value_data("timer", timer)
	
func load_timer() -> void:
	var loaded_time = DOT_save.get_value_data("timer")
	if loaded_time:
		timer = loaded_time
