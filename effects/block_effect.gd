class_name BlockEffect
extends Effect

# Value to override
var amount := 0


func execute(targets: Array[Node]) -> void:
	for target in targets:
		if not target:
			continue
		if target is Enemy or target is Player:
			target.stats.block += amount
			SFXPlayer.play(sound)
