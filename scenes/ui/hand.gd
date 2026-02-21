class_name Hand
extends HBoxContainer

@export var char_stats: CharacterStats

@onready var card_ui := preload("res://scenes/card_ui/card_ui.tscn")
		

func add_card(card: Card) -> void:
	var new_card_ui := card_ui.instantiate()
	add_child(new_card_ui)
	new_card_ui.reparent_requested.connect(_on_card_ui_reparent_requested)
	new_card_ui.card = card
	new_card_ui.parent = self
	new_card_ui.char_stats = char_stats


func discard_card(card: CardUI) -> void:
	card.queue_free()


# Discarding animation takes time, meanwhile we don't want the 
# player to interact with the cards.
func disable_hand() -> void:
	for card in get_children():
		card.disabled = true
	
	
func _on_card_ui_reparent_requested(child: CardUI) -> void:
	child.disabled = true
	child.reparent(self)
	# Make sure card stays in same relative position when it pops back to hand
	var new_index := clampi(child.original_index, 0, get_child_count())
	# call_deferred: make sure this happens at end of the frame
	move_child.call_deferred(child, new_index)
	child.set_deferred("disabled", false)
