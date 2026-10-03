extends HSlider


func _ready() -> void:
	value_changed.connect(on_value_changed)
	CustomisationManager.customisation_updated.connect(refresh_colour)

func refresh_colour() -> void:
	value = CustomisationManager.player_pattern_strength
	
func on_value_changed(new_value: float) -> void:
	CustomisationManager.player_pattern_strength = new_value
