class_name InteractionArea2D extends Area2D

signal interacted

var contained_interactors: Array[InteractorArea2D]

func _ready() -> void:
	area_entered.connect(on_area_entered)
	area_exited.connect(on_area_exited)
	
func on_area_entered(area) -> void:
	if area is InteractorArea2D:
		if area.interaction_enabled:
			contained_interactors.append(area)
			area.can_interact = true

func on_area_exited(area) -> void:
	if area in contained_interactors:
		contained_interactors.erase(area)
		area.can_interact = false

func can_interact() -> bool:
	return not contained_interactors.is_empty()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if can_interact():
			interacted.emit()
