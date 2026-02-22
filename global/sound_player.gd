extends Node


func play(audio: AudioStream, single=false) -> void:
	if not audio:
		return
		
	# Stop all audio players before playing the new sound
	if single:
		stop()

	for player: AudioStreamPlayer in get_children():
		# Find players which are free (not playing other sounds)
		if not player.playing:
			player.stream = audio
			player.play()
			break


func stop() -> void:
	for player: AudioStreamPlayer in get_children():
		player.stop()
