extends Label

func _ready() -> void:
	text = "Build " + ProjectSettings.get_setting("application/config/version")
	print("Got version number ", text)
