extends Node2D

@export var rope_start: Node2D
@export var rope_end: Node2D

@onready var line_2d: Line2D = $Line2D

func _ready() -> void:
	line_2d.add_point(rope_start.position)
	line_2d.add_point(rope_end.position)

func _physics_process(_delta: float) -> void:
	line_2d.set_point_position(0, rope_start.position)
	line_2d.set_point_position(1, rope_end.position)
