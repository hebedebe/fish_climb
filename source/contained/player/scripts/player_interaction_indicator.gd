extends Sprite2D

@export var interactor_area: InteractorArea2D

func _ready() -> void:
	interactor_area.interactable_state_changed.connect(on_interactable_state_changed)
	visible = interactor_area.can_interact

func on_interactable_state_changed(state) -> void:
	visible = state
