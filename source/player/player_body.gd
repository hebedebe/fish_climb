@warning_ignore("missing_tool")
class_name PlayerBody extends SoftBody2D

enum FlipDirection {
	LEFT,
	RIGHT,
}

var stable_center_node: Node2D

func _ready():
	stable_center_node = get_center_body().rigidbody
	CustomisationManager.customisation_updated.connect(update_customisation)

func get_center_global_position() -> Vector2:
	return stable_center_node.global_position

func flip(strength: float, flip_direction: FlipDirection) -> void:
	var center_global_position = get_center_global_position()
	match flip_direction:
		FlipDirection.LEFT:
			apply_torque_impulse(strength, center_global_position)
		FlipDirection.RIGHT:
			apply_torque_impulse(-strength, center_global_position)

func update_customisation() -> void:
	var shader_material: ShaderMaterial = material
	if not CustomisationManager.player_pattern_path.is_empty():
		shader_material.set_shader_parameter("pattern", load(CustomisationManager.player_pattern_path))
	shader_material.set_shader_parameter("pattern_tint", CustomisationManager.player_pattern_tint)
	shader_material.set_shader_parameter("base_tint", CustomisationManager.player_base_tint)
	shader_material.set_shader_parameter("pattern_strength", CustomisationManager.player_pattern_strength)
