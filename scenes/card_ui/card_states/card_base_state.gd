extends CardState


func enter() -> void:
	# Children gets ready first, parent only ready when all children ready.
	# So we need to wait for CardUI to be ready, otherwise it's possible that
	# we enter base state earlier than CardUI is fully initialized.
	if not card_ui.is_node_ready():
		await card_ui.ready
		
	if card_ui.tween and card_ui.tween.is_running():
		card_ui.tween.kill()
	
	card_ui.panel.set("theme_override_styles/panel", card_ui.BASE_STYLEBOX)
		
	# Without reparenting request, card won't snap back to hand when it returns base state
	card_ui.reparent_requested.emit(card_ui)
	# Reason we might change pivot_offset in other state:
	# We don't want the top left of the card to snap to the mouse cursor
	# when we drag it, but rather to the point where we click on the card.
	# e.g. if user clicks middle of the card, the top left of the card will
	# jump to the mouse cursor if pivot_offset equals 0.
	# Here in base state, we simply reset it to 0.
	card_ui.pivot_offset = Vector2.ZERO
	Events.tooltip_hide_requested.emit()


func on_gui_input(event: InputEvent) -> void:
	if not card_ui.playable or card_ui.disabled:
		return
		
	# Need to define action in Project Settings for this to work
	if event.is_action_pressed("left_mouse"):
		card_ui.pivot_offset = card_ui.get_global_mouse_position() - card_ui.global_position
		transition_requested.emit(self, CardState.State.CLICKED)
		
		
func on_mouse_entered() -> void:
	if not card_ui.playable or card_ui.disabled:
		return
		
	card_ui.panel.set("theme_override_styles/panel", card_ui.HOVER_STYLEBOX)
	# What is emitted must match the handler signature
	Events.card_tooltip_requested.emit(card_ui.card.icon, card_ui.card.tooltip_text)
	
	
func on_mouse_exited() -> void:
	if not card_ui.playable or card_ui.disabled:
		return
		
	card_ui.panel.set("theme_override_styles/panel", card_ui.BASE_STYLEBOX)
	Events.tooltip_hide_requested.emit()
