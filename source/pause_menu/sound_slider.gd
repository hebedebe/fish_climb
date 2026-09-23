class_name SoundSlider extends HSlider

@export_group("Audio Bus")
@export var target_bus: StringName

func _ready() -> void:
	if target_bus.is_empty():
		printerr("No target bus set")
		return
	
	#value = get_bus_volume_linear()
	update_bus_value()
	value_changed.connect(update_bus_value.unbind(1))

func update_bus_value() -> void:
	var bus_index = AudioServer.get_bus_index(target_bus)
	if bus_index >= 0:
		AudioServer.set_bus_volume_linear(bus_index, value)
		print("Set bus (%s) volume to %s (linear)" % [target_bus, value])

func get_bus_volume_linear() -> float:
	var bus_index = AudioServer.get_bus_index(target_bus)
	if bus_index >= 0:
		return AudioServer.get_bus_volume_linear(bus_index)
	return 0
