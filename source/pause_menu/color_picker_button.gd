extends ColorPickerButton

func _ready() -> void:
	get_picker().can_add_swatches = false
	get_picker().edit_alpha = false
	get_picker().edit_intensity = false
	get_picker().presets_visible = false
	get_picker().hex_visible = false
	get_picker().sampler_visible = false
	get_picker().sliders_visible = false
	get_picker().color_modes_visible = false
	get_picker().picker_shape = ColorPicker.SHAPE_VHS_CIRCLE
	
	get_picker().color_changed.connect(update_fish_colour.unbind(1))
	
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
