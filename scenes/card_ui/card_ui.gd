# Assign a class name so it's a recognizable static type throughout the project
class_name CardUI
extends Control

# Defines a custom signal. How it works:
# 1. Player clicks a card
# 2. CardUI.start_drag() runs, which calls reparent_requested.emit(self)
# 3. HandUI receives the signal, as it has code:
#    card.reparent_requested.connect(_on_card_reparent_requested)
# 4. Func _on_card_reparent_requested gets invoked, 
#    which executes the actual logic to handle reparenting
# In this case, it is needed so that it can move beyond container's fixed size.
signal reparent_requested(which_card_ui: CardUI)

const BASE_STYLEBOX := preload("res://scenes/card_ui/card_base_stylebox.tres")
const DRAG_STYLEBOX := preload("res://scenes/card_ui/card_drag_stylebox.tres")
const HOVER_STYLEBOX := preload("res://scenes/card_ui/card_hover_stylebox.tres")

# Use setter to wire up CardUI with actual icon and cost,
# not dummy ones set in the Inspector
@export var card: Card: set = _set_card
@export var char_stats: CharacterStats : set = _set_char_stats

# CardUI
#  - Color
#  - State
# @onready var color: ColorRect = $Color
# @onready var state: Label = $State
# This code gets the two child nodes themselves, $ is short for get_node()
# @onready is needed to make sure when this code runs, child nodes exist in the scene tree
@onready var panel: Panel = $Panel
@onready var cost: Label = $Cost
@onready var icon: TextureRect = $Icon
@onready var drop_point_detector: Area2D = $DropPointDetector
@onready var card_state_machine: CardStateMachine = $CardStateMachine
@onready var targets: Array[Node] = []
@onready var original_index := self.get_index()

# Need access to parent for the aiming
# Used in state machine like card_ui.parent
var parent: Control
# Used to animate changes over time, needed for the aiming animation
var tween: Tween
# Has mana to play the card or not
var playable := true : set = _set_playable
# Can interact with the card on UI or not
# (can't drag other cards when you are already dragging a card)
var disabled := false


# Wirp up the state machine by calling init().
func _ready() -> void:
	Events.card_aim_started.connect(_on_card_drag_or_aiming_started)
	Events.card_drag_started.connect(_on_card_drag_or_aiming_started)
	Events.card_drag_ended.connect(_on_card_drag_or_aim_ended)
	Events.card_aim_ended.connect(_on_card_drag_or_aim_ended)
	card_state_machine.init(self)
	

# _ready and _input callbacks are inherited from Node, no need to connect.
func _input(event: InputEvent) -> void:
	card_state_machine.on_input(event)
	
	
func play() -> void:
	if not card:
		return
		
	card.play(targets, char_stats)
	queue_free()
	
	
func animate_to_position(new_position: Vector2, duration: float) -> void:
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", new_position, duration)
	
	
# Custom callbacks such as _on_gui_input need to be connected to user actions manually in 2D console.
func _on_gui_input(event: InputEvent) -> void:
	card_state_machine.on_gui_input(event)


func _on_mouse_entered() -> void: 
	card_state_machine.on_mouse_entered()


func _on_mouse_exited() -> void:
	card_state_machine.on_mouse_exited()
	
	
func _set_card(value: Card) -> void:
	if not is_node_ready():
		await ready

	card = value
	cost.text = str(card.cost)
	icon.texture = card.icon


func _set_playable(value: bool) -> void:
	playable = value
	if not playable:
		cost.add_theme_color_override("font_color", Color.RED)
		icon.modulate = Color(1, 1, 1, 0.5)
	else:
		cost.remove_theme_color_override("font_color")
		icon.modulate = Color(1, 1, 1, 1)
		

func _set_char_stats(value: CharacterStats) -> void:
	char_stats = value
	char_stats.stats_changed.connect(_on_char_stats_changed)
	
	
func _on_drop_point_detector_area_entered(area: Area2D) -> void:
	if not targets.has(area):
		targets.append(area)


func _on_drop_point_detector_area_exited(area: Area2D) -> void:
	targets.erase(area)
	
	
func _on_card_drag_or_aiming_started(used_card: CardUI) -> void:
	# If we are dragging the card itself, no need to disable,
	# only disable other cards.
	if used_card == self:
		return
	
	disabled = true


func _on_card_drag_or_aim_ended(_card: CardUI) -> void:
	disabled = false
	self.playable = char_stats.can_play_card(card)


func _on_char_stats_changed() -> void:
	self.playable = char_stats.can_play_card(card)
