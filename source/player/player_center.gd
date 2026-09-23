extends Node2D

@export var player_body: PlayerBody

func _process(_delta: float) -> void:
	global_position = player_body.get_center_global_position()
	pass
