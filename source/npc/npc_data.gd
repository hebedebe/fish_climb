@tool
@icon("uid://fym6ercmrlns")
class_name NpcData extends Resource

@export_group("Sprite")
@export var npc_sprite: Texture2D:
	set(value):
		npc_sprite = value
		emit_changed()

@export var sprite_position: Vector2 = Vector2.ZERO:
	set(value):
		sprite_position = value
		emit_changed()
		
@export var sprite_rotation: float = 0:
	set(value):
		sprite_rotation = value
		emit_changed()
		
@export var sprite_scale: Vector2 = Vector2.ONE:
	set(value):
		sprite_scale = value
		emit_changed()
		
@export var sprite_skew: float = 0:
	set(value):
		sprite_skew = value
		emit_changed()

@export var sprite_texture_filter: Sprite2D.TextureFilter = Sprite2D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS:
	set(value):
		sprite_texture_filter = value
		emit_changed()

@export_group("Npc")
@export var npc_name: String:
	set(value):
		npc_name = value
		emit_changed()

@export var npc_dialogue: DialogueResource:
	set(value):
		npc_dialogue = value
		emit_changed()
		
@export var npc_dialogue_balloon: PackedScene = preload("uid://db48e8dt0fpc0"):
	set(value):
		npc_dialogue_balloon = value
		emit_changed()
