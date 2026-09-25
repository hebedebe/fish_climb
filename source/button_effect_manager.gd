@tool
class_name ButtonEffectManager extends Node

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

@onready var owning_button: Button = $".."

func _ready() -> void:
	assert(owning_button != null, "ButtonEffectManager must be placed as a child of an owning button")
	
	hover_sound_player = AudioStreamPlayer.new()
	hover_sound_player.bus = "SFX"
	owning_button.mouse_entered.connect(hover_sound_player.play)
	add_child(hover_sound_player)
	
	pressed_sound_player = AudioStreamPlayer.new()
	pressed_sound_player.bus = "SFX"
	owning_button.pressed.connect(pressed_sound_player.play)
	add_child(pressed_sound_player)
	
	update_sounds()

func update_sounds() -> void:
	if hover_sound_player:
		hover_sound_player.stream = hover_sound
		hover_sound_player.volume_db = hover_sound_volume
		
	if pressed_sound_player:
		pressed_sound_player.stream = pressed_sound
		pressed_sound_player.volume_db = pressed_sound_volume
