extends CardState

var played: bool


func enter() -> void:
	played = false
	
	if not card_ui.targets.is_empty():
		# Meaning Area2D is added to target list, card arrives at drop area
		played = true
		print("play card for target(s) ", card_ui.targets)


func on_input(_event: InputEvent) -> void:
	if played:
		return
		
	transition_requested.emit(self, CardState.State.BASE)
