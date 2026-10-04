extends SquishButton

func _ready() -> void:
	super._ready()
	pressed.connect(on_pressed)

func on_pressed() -> void:
	SaveManager.save_game(SaveManager.SaveMode.Game)
	SaveManager.save_game(SaveManager.SaveMode.Settings)
	get_tree().quit()
