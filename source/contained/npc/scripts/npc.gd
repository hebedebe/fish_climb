@tool
@icon("res://addons/at-icons/node2d/human.svg")
class_name Npc extends Node2D

@export var npc_data: NpcData:
	set(value):
		npc_data = value
		npc_data.changed.connect(editor_update)
		editor_update()

@export var interaction_shape: Shape2D:
	set(value):
		interaction_shape = value
		if interaction_area_collider:
			interaction_area_collider.shape = interaction_shape

var sprite: Sprite2D
var interaction_area: InteractionArea2D
var interaction_area_collider: CollisionShape2D
var voice_player: AudioStreamPlayer2D

func _ready() -> void:
	initialise_nodes()
	update_nodes()
	
func initialise_nodes() -> void:
	sprite = Sprite2D.new()
	add_child(sprite)
	
	interaction_area = InteractionArea2D.new()
	add_child(interaction_area)
	interaction_area.interacted.connect(show_dialogue)
	
	interaction_area_collider = CollisionShape2D.new()
	interaction_area.add_child(interaction_area_collider)
	interaction_area_collider.shape = interaction_shape
	
	voice_player = AudioStreamPlayer2D.new()
	add_child(voice_player)

func update_nodes() -> void:
	if not npc_data:
		return
		
	if sprite:
		sprite.texture = npc_data.npc_sprite
		sprite.position = npc_data.sprite_position
		sprite.rotation = npc_data.sprite_rotation
		sprite.scale = npc_data.sprite_scale
		sprite.skew = npc_data.sprite_skew
		sprite.texture_filter = npc_data.sprite_texture_filter
	
	if voice_player:
		voice_player.stream = npc_data.talk_sound
		voice_player.volume_db = npc_data.talk_volume

func show_dialogue() -> void:
	voice_player.play()
	if npc_data.npc_dialogue_balloon:
		DialogueManager.show_dialogue_balloon_scene(npc_data.npc_dialogue_balloon, npc_data.npc_dialogue)
	else:
		DialogueManager.show_dialogue_balloon(npc_data.npc_dialogue)

func editor_update() -> void:
	if Engine.is_editor_hint():
		update_nodes()
		print("Performed npc editor update.")
