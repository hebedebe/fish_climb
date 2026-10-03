extends AudioStreamPlayer2D

@export var delay: float = 0.6

var last_play_time: float = 0.0

func start() -> void:
	if Time.get_ticks_msec() - last_play_time > delay*1000:
		play()
		last_play_time = Time.get_ticks_msec()
