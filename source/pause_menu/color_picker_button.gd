extends ColorPickerButton

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
	
	SaveManager.bind_save_function(save_game)
	SaveManager.bind_load_function(load_game)

func update_fish_colour() -> void:
	var player: Player = get_tree().get_first_node_in_group("player")
	player.player_body.self_modulate = get_picker().color
	color = get_picker().color

func save_game() -> void:
	DOT_save.set_value_data("fish_tint", get_picker().color)
	
func load_game() -> void:
	var tint = DOT_save.get_value_data("fish_tint")
	if tint:
		get_picker().color = DOT_save.get_value_data("fish_tint")
		update_fish_colour()
