extends CheckBox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(on_pressed)
	on_pressed()
	
func on_pressed() -> void:
	if button_pressed:
		RenderingServer.viewport_set_msaa_2d(get_viewport().get_viewport_rid(), 
			RenderingServer.VIEWPORT_MSAA_8X)
	else:
		RenderingServer.viewport_set_msaa_2d(get_viewport().get_viewport_rid(), 
			RenderingServer.VIEWPORT_MSAA_DISABLED)
