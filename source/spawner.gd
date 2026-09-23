class_name Spawner extends Node2D

@export var scene_to_spawn: PackedScene

@export var spawn_on_ready: bool = true

func _ready() -> void:
	if spawn_on_ready and scene_to_spawn:
		var scene = scene_to_spawn.instantiate()
		add_child(scene)
