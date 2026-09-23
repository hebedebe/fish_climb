extends AudioStreamPlayer2D

@export var player: Player

var playback: AudioStreamGeneratorPlayback

func _process(_delta: float) -> void:
	if player.charging and not playing:
		pitch_scale = lerpf(0.7, 1.0, player.get_charge_factor())
		print(pitch_scale)
		play()
