extends ColorPickerButton

@export var target_property: StringName

func _ready() -> void:
	var picker := get_picker()
	if not picker:
		printerr("Could not get picker")
		return
		
	picker.can_add_swatches = false
	picker.edit_alpha = false
	picker.edit_intensity = false
	picker.presets_visible = false
	picker.hex_visible = false
	picker.sampler_visible = false
	picker.sliders_visible = false
	picker.color_modes_visible = false
	picker.picker_shape = ColorPicker.SHAPE_VHS_CIRCLE
	
	color_changed.connect(update_fish_colour.unbind(1))
	
	refresh_colour()
	
	CustomisationManager.customisation_updated.connect(refresh_colour)

func refresh_colour() -> void:
	get_picker().color = CustomisationManager.get(target_property)
	color = CustomisationManager.get(target_property)

func update_fish_colour() -> void:
	CustomisationManager.set(target_property, get_picker().color)
	color = get_picker().color
