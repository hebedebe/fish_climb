extends SquishButton

func _ready() -> void:
	super._ready()
	pressed.connect(on_pressed)

func on_pressed() -> void:
	get_tree().quit()
