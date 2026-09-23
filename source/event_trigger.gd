@icon("uid://c7dllgvw5vjev")
class_name EventTrigger
extends Node


@export_category("Events")
@export var trigger_callbacks: Dictionary[StringName, String]


func _ready() -> void:
	GameplayEvents.event.connect(handle_event)


func handle_event(event_name: StringName) -> void:
	if event_name in trigger_callbacks.keys():
		var target = get_parent()[trigger_callbacks[event_name]]
		if target is Callable:
			target.call()
		else:
			print("Invalid path to callable in parent")
