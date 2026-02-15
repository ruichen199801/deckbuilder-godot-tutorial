extends Card

var base_damage := 6


func apply_effects(targets: Array[Node]) -> void:
	var damage_effect := DamageEffect.new()
	damage_effect.amount = base_damage
	damage_effect.execute(targets)
	
