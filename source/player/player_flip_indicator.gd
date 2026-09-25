extends Sprite2D

@export var player: Player
@export var flip_direction: PlayerBody.FlipDirection
@export var charge_visibility_threshold: float = 0.1
@export var animation_time: float = 0.1
@export var shake_amplitude: float = 12.0
@export var shake_frequency: float = 1.0

var _visible: bool = false

var shake_noise: FastNoiseLite

func _ready() -> void:
	scale = Vector2.ZERO
	shake_noise = FastNoiseLite.new()

func _process(_delta: float) -> void:
	set_visibility(player.charging and player.flip_direction == flip_direction and player.get_charge_factor() > charge_visibility_threshold)
	self_modulate = Color.WHITE.lerp(Color.RED, player.get_charge_factor())
	if player.get_charge_factor() >= 1:
		var time := Time.get_ticks_msec() * shake_frequency
		offset = Vector2(
			shake_amplitude * shake_noise.get_noise_1d(global_position.x + time),
			shake_amplitude * shake_noise.get_noise_1d(global_position.y + time)
		)

func set_visibility(visibility: bool) -> void:
	if visibility == _visible:
		return
	_visible = visibility
	if _visible:
		appear()
	else:
		disappear()

func appear() -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "scale", Vector2.ONE, animation_time)
	tween.play()
	#print("appear")
	
func disappear() -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "scale", Vector2.ZERO, animation_time)
	tween.play()
	#print("disappear")
