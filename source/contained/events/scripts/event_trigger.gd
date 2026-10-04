@icon("uid://c7dllgvw5vjev")
class_name EventTrigger
extends Node


@export_category("Events")
@export var trigger_callbacks: Dictionary[StringName, String]

var _processed_trigger_callbacks: Dictionary[StringName, Callable]

func _ready() -> void:
	process_callback_list()
	GameplayEvents.event.connect(handle_event)

func process_callback_list() -> void:
	for key in trigger_callbacks.keys():
		process_callback(key, trigger_callbacks[key])

func process_callback(callback_key: String, callback_name: String) -> void:
	var callback := get_callback_from_name(callback_name)
	if callback:
		_processed_trigger_callbacks[callback_key] = callback

func get_callback_from_name(callback_name: String) -> Callable:
	assert(get_parent().has_method(callback_name), "%s is not a callable in parent node." % callback_name)
	var callback = get_parent()[callback_name]
	return callback

func handle_event(event_name: StringName) -> void:
	if _processed_trigger_callbacks.has(event_name):
		_processed_trigger_callbacks[event_name].call()
		#print("%s executed callback %s from %s" % [get_parent(), _processed_trigger_callbacks[event_name], event_name])

func add_callback_by_name(broadcast_name: StringName, method_name: String) -> void:
	process_callback(broadcast_name, method_name)

func add_callback(broadcast_name: StringName, callback: Callable) -> void:
	_processed_trigger_callbacks[broadcast_name] = callback
