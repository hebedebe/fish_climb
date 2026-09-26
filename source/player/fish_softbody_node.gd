extends RigidBody2D

@export var impulse_sound_threshold: float = 10.0

func _ready() -> void:
	DOT_save.data_is_saving.connect(save_data)
	DOT_save.data_is_loading.connect(load_data)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var contact_count = state.get_contact_count()
	var total_impulse := Vector2.ZERO
	for i in range(contact_count):
		var impulse := state.get_contact_impulse(i)
		total_impulse += impulse

	# this will be the total amount of impact (in any direction) applied thiss physics frame
	var impulse_length := total_impulse.length()

	if impulse_length > impulse_sound_threshold:
		GameplayEvents.broadcast("FishSlapSound")

func save_path(property_name: String) -> String:
	return name + "." + property_name

func save_data() -> void:
	DOT_save.set_value_data(save_path("position"), position)
	DOT_save.set_value_data(save_path("rotation"), rotation)
	DOT_save.set_value_data(save_path("linear_velocity"), linear_velocity)
	DOT_save.set_value_data(save_path("angular_velocity"), angular_velocity)
	
func load_data() -> void:
	position = DOT_save.get_value_data(save_path("position"))
	rotation = DOT_save.get_value_data(save_path("rotation"))
	linear_velocity = DOT_save.get_value_data(save_path("linear_velocity"))
	angular_velocity = DOT_save.get_value_data(save_path("angular_velocity"))
