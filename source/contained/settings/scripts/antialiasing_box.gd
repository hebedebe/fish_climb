extends CheckBox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Utilities.is_web_export():
		print("Disabling antialiasing option in web export")
		var disabled_label := Label.new()
		disabled_label.text = "Disabled in web build."
		disabled_label.add_theme_color_override("font_color", Color.RED)
		disabled_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		get_parent().add_child.call_deferred(disabled_label)
		queue_free()
		return
	pressed.connect(on_pressed)
	on_pressed()
	
func on_pressed() -> void:
	if button_pressed:
		RenderingServer.viewport_set_msaa_2d(get_viewport().get_viewport_rid(), 
			RenderingServer.VIEWPORT_MSAA_8X)
	else:
		RenderingServer.viewport_set_msaa_2d(get_viewport().get_viewport_rid(), 
			RenderingServer.VIEWPORT_MSAA_DISABLED)
