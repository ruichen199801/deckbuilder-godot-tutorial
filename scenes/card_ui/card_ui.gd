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

@export var card: Card

# CardUI
#  - Color
#  - State
# This code gets the two child nodes themselves, $ is short for get_node()
# @onready is needed to make sure when this code runs, child nodes exist in the scene tree
@onready var color: ColorRect = $Color
@onready var state: Label = $State
@onready var drop_point_detector: Area2D = $DropPointDetector
@onready var card_state_machine: CardStateMachine = $CardStateMachine
@onready var targets: Array[Node] = []

# Need access to parent for the aiming
var parent: Control
# Used to animate changes over time, needed for the aiming animation
var tween: Tween


# Wirp up the state machine by calling init().
func _ready() -> void:
	card_state_machine.init(self)
	

# _ready and _input callbacks are inherited from Node, no need to connect.
func _input(event: InputEvent) -> void:
	card_state_machine.on_input(event)
	
	
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


func _on_drop_point_detector_area_entered(area: Area2D) -> void:
	if not targets.has(area):
		targets.append(area)


func _on_drop_point_detector_area_exited(area: Area2D) -> void:
	targets.erase(area)
