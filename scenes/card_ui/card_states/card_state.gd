class_name CardState
extends Node

# Card UI State Machine
# BASE -> CLICKED      : LMB
# CLICKED -> DRAGGING  : mouse motion
# DRAGGING -> BASE     : RMB
# DRAGGING -> RELEASED : LMB pressed or released
# RELEASED -> BASE     : is outside drop area
enum State {BASE, CLICKED, DRAGGING, AIMING, RELEASED}

signal transition_requested(from: CardState, to: State)

# @export means making this variable editable in the Inspector
@export var state: State

var card_ui: CardUI

# Think of these functions as interfaces.
# Child class can override some of them as they need.
func enter() -> void:
	pass
	
	
func exit() -> void:
	pass


func on_input(_event: InputEvent) -> void:
	pass


# Can be UI input only, e.g. click an UI element
func on_gui_input(_event: InputEvent) -> void:
	pass


func on_mouse_entered() -> void:
	pass


func on_mouse_exited() -> void:
	pass
