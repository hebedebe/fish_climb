@warning_ignore("missing_tool")
class_name PlayerBody extends SoftBody2D

signal completed_flip ## player flipped 180 degrees

enum FlipDirection {
	LEFT,
	RIGHT,
}

var stable_center_node: Node2D

func _ready():
	stable_center_node = get_center_body().rigidbody

func get_center_global_position() -> Vector2:
	return stable_center_node.global_position

func flip(strength: float, flip_direction: FlipDirection) -> void:
	var center_global_position = get_center_global_position()
	match flip_direction:
		FlipDirection.LEFT:
			apply_torque_impulse(strength, center_global_position)
		FlipDirection.RIGHT:
			apply_torque_impulse(-strength, center_global_position)
