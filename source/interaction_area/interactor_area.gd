class_name InteractorArea2D extends Area2D

signal entered_interactable
signal exited_interactable
signal interactable_state_changed(state)

@export var interaction_enabled: bool = true

var can_interact: bool = false:
	set(value):
		can_interact = value
		interactable_state_changed.emit(value)
		if can_interact:
			entered_interactable.emit()
		else:
			exited_interactable.emit()
