class_name CardState
extends Node

# Card UI State Machine
# BASE -> CLICKED      : LMB
# CLICKED -> DRAGGING  : mouse motion
# DRAGGING -> BASE     : RMB
# DRAGGING -> RELEASED : LMB pressed or released
# DRAGGING -> AIMING   : single-targeted & mouse motion & is inside drop area
# AIMING -> RELEASED   : LMB pressed or released
# AIMING -> BASE       : RMB or at bottom
# RELEASED -> BASE     : is outside drop area
#
# Flow: card_ui -on user event-> card_state_machine -> card_x_state
# enter() / exit(): UI related actions (change properties, animations, etc.)
# on_xxx(): send state transition request signal
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
