extends LineEdit

func _ready() -> void:
	text_changed.connect(on_text_changed)
	on_text_changed(text)
	
func on_text_changed(new_text: String) -> void:
	LeaderboardManager.player_name = new_text

func refresh_player_name() -> void:
	on_text_changed(text)
