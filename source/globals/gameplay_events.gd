extends Node

signal event(event_name: StringName)

func broadcast(event_name: StringName) -> void:
	event.emit(event_name)
	#print("Broadcast global event ", event_name)
