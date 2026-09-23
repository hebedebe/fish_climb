extends Sprite2D

@export var player_body: RigidBody2D

@export_category("VFX")
@export var velocity_stretch_scale: float = 0.01
@export var max_velocity_stretch: float = 0.2

func _process(delta: float) -> void:
	var velocity_stretch: float = minf(max_velocity_stretch, absf(player_body.angular_velocity) * velocity_stretch_scale)
	scale = Vector2(1.0+velocity_stretch, 1.0-velocity_stretch)
