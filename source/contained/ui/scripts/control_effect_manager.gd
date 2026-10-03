@tool
@icon("res://addons/at-icons/control/stars.svg")
class_name ControlEffectManager extends Control

signal empty

@export_group("Sounds")
@export_subgroup("Hover")
@export var hover_sound: AudioStream:
	set(value):
		hover_sound = value
		update_sounds()
@export var hover_sound_volume: float:
	set(value):
		hover_sound_volume = value
		update_sounds()

@export_subgroup("Pressed")
@export var pressed_sound: AudioStream:
	set(value):
		pressed_sound = value
		update_sounds()
@export var pressed_sound_volume: float:
	set(value):
		pressed_sound_volume = value
		update_sounds()

var hover_sound_player: AudioStreamPlayer
var pressed_sound_player: AudioStreamPlayer

func _ready() -> void:
	assert(get_parent_control() != null, "ButtonEffectManager must be placed as a child of an owning button")
	
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	hover_sound_player = AudioStreamPlayer.new()
	hover_sound_player.bus = &"UI"
	get_hover_signal().connect(hover_sound_player.play)
	add_child(hover_sound_player)
	
	pressed_sound_player = AudioStreamPlayer.new()
	pressed_sound_player.bus = &"UI"
	get_pressed_signal().connect(pressed_sound_player.play)
	add_child(pressed_sound_player)
	
	update_sounds()

func update_sounds() -> void:
	if hover_sound_player:
		hover_sound_player.stream = hover_sound
		hover_sound_player.volume_db = hover_sound_volume
		
	if pressed_sound_player:
		pressed_sound_player.stream = pressed_sound
		pressed_sound_player.volume_db = pressed_sound_volume

func parent_has_signal(signal_name: StringName) -> bool:
	var parent := get_parent_control()
	if not parent:
		return false
	return parent.has_signal(signal_name)

func get_pressed_signal() -> Signal:
	if parent_has_signal("pressed"):
		return get_parent_control().pressed
	if parent_has_signal("folding_changed"):
		return get_parent_control().folding_changed
	if parent_has_signal("item_selected"):
		return get_parent_control().item_selected
	return empty

func get_hover_signal() -> Signal:
	if parent_has_signal("mouse_entered"):
		return get_parent_control().mouse_entered
	return empty
