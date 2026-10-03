class_name SoundSlider extends HSlider

@export_group("Audio Bus")
@export var target_bus: StringName
@export_group("Tick sound")
@export var tick_sound: AudioStream:
	set(value):
		tick_sound = value
		if tick_sound_player:
			tick_sound_player.stream = tick_sound
@export var tick_volume: float:
	set(value):
		tick_volume = value
		if tick_sound_player:
			tick_sound_player.volume_db = tick_volume

var tick_sound_player: AudioStreamPlayer

func _ready() -> void:
	if target_bus.is_empty():
		printerr("No target bus set")
		return
	
	#value = get_bus_volume_linear()
	tick_sound_player = AudioStreamPlayer.new()
	add_child(tick_sound_player)
	tick_sound_player.bus = &"UI"
	tick_sound_player.stream = tick_sound
	tick_sound_player.max_polyphony = 16
	tick_sound_player.volume_db = tick_volume
	
	update_bus_value(false)
	value_changed.connect(update_bus_value.unbind(1))

func update_bus_value(play_sound: bool = true) -> void:
	var bus_index = AudioServer.get_bus_index(target_bus)
	if bus_index >= 0:
		AudioServer.set_bus_volume_linear(bus_index, value)
		if play_sound:
			tick_sound_player.pitch_scale = lerpf(0.5, 1.0, value)
			tick_sound_player.play()
		print("Set bus (%s) volume to %s (linear)" % [target_bus, value])

func get_bus_volume_linear() -> float:
	var bus_index = AudioServer.get_bus_index(target_bus)
	if bus_index >= 0:
		return AudioServer.get_bus_volume_linear(bus_index)
	return 0
