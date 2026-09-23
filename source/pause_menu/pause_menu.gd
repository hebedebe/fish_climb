extends CanvasLayer

@onready var pause_menu: Control = $PauseMenu


func _ready() -> void:
	update_pause_menu_visibility()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause() -> void:
	get_tree().paused = !get_tree().paused
	update_pause_menu_visibility()
	
func update_pause_menu_visibility() -> void:
	pause_menu.visible = get_tree().paused
