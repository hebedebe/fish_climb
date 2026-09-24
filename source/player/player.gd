@icon("uid://cpkbt8vxhxfjc")
class_name Player extends Node2D

@export var player_body: PlayerBody

@export_group("Movement")
@export var flip_strength: float = 60.0
@export var flip_charge_time: float = 1.0

var charging := false
var charge: float = 0.0
var flip_direction: PlayerBody.FlipDirection

func _process(delta: float) -> void:
	if charging:
		charge = clamp(charge + flip_strength * delta/flip_charge_time, 0, flip_strength)
		#print(charge)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("flip_left"):
		charge_pressed()
		flip_direction = PlayerBody.FlipDirection.LEFT
	if event.is_action_pressed("flip_right"):
		charge_pressed()
		flip_direction = PlayerBody.FlipDirection.RIGHT
	
	if event.is_action_released("flip_left") or event.is_action_released("flip_right"):
		player_body.flip(charge, flip_direction)
		stop_charging()

func charge_pressed() -> void:
	if charging:
		stop_charging()
		print("Cancelled charge")
	else:
		charging = true

func stop_charging() -> void:
	charge = 0.0
	charging = false

## return the charge amount from 0-1
func get_charge_factor() -> float:
	return charge / flip_strength
