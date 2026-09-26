class_name EventBroadcaster extends Node

@export var broadcast_string: StringName

func broadcast() -> void:
	GameplayEvents.broadcast(broadcast_string)
