extends RigidBody2D

@export var impulse_sound_threshold: float = 10.0

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
