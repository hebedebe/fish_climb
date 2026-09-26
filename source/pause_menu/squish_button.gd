extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_down.connect(on_button_down)
	button_up.connect(on_button_up)
	offset_transform_enabled = true
	
func on_button_down() -> void:
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "offset_transform_scale", Vector2(1.1, 0.9), 0.5)
	tween.play()

func on_button_up() -> void:
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "offset_transform_scale", Vector2.ONE, 0.5)
	tween.play()
