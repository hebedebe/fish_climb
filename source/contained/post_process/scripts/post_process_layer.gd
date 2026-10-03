@tool
class_name PostProcessLayer extends CanvasLayer

@export var material: ShaderMaterial

var color_rect: ColorRect

func _ready() -> void:
	if not material:
		material = ShaderMaterial.new()
	color_rect = ColorRect.new()
	add_child(color_rect)
	color_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	color_rect.material = material
