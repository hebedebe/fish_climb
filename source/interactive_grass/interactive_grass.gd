class_name InteractiveGrass
extends Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var skew_value: float = 500.0
@export var bend_grass_animation_speed: float = 0.3
@export var grass_return_animation_speed: float = 5.0

func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		var direction = global_position.direction_to(body.global_position)
		var grass_skew: int = -direction.x * skew_value
		
		var tween = create_tween()
		tween.tween_property(
			sprite_2d.material,
			"shader_parameter/skew",
			grass_skew,
			bend_grass_animation_speed
		).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		
		tween.tween_property(
			sprite_2d.material,
			"shader_parameter/skew",
			0.0,
			grass_return_animation_speed
		).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	
