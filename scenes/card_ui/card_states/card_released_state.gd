extends CardState

var played: bool


func enter() -> void:
	played = false
	
	if not card_ui.targets.is_empty():
		Events.tooltip_hide_requested.emit()
		# Meaning Area2D is added to target list, card arrives at drop area
		played = true
		print("play card for target(s) ", card_ui.targets)
		card_ui.play()


func on_input(_event: InputEvent) -> void:
	if played:
		return
		
	transition_requested.emit(self, CardState.State.BASE)
