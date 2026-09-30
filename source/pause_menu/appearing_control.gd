class_name AppearingControl extends Control

var tween: Tween

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func appear() -> void:
	var parent: Control = get_parent()
	offset_transform_scale = Vector2.ZERO
	if tween:
		tween.stop()
	tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(parent, "offset_transform_scale", Vector2.ONE, 0.5)
	tween.play()
