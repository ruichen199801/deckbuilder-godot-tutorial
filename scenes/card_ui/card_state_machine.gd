# If we want scene-tree events or child-node references in the logic, we must 
# attach the script to a node. That's why we make a general node called
# CardStateMachine and attach the script to it.
class_name CardStateMachine
extends Node

# Let you assign BASE in the Inspector
@export var initial_state: CardState

var current_state: CardState
# Store all the available states in the state machine
# Dict of <State, CardState>
var states := {}

# Populate states dict and initialize current_state
func init(card: CardUI) -> void:
	# Iterate all immediate children of the state machine
	# OOD: CardState is the interface, actual type will be its child class,
	# such as CardBaseState, etc.
	for child in get_children():
		if child is CardState:
			states[child.state] = child
			# Connect signal to handler
			child.transition_requested.connect(_on_transition_requested)
			# Dependency injection: Give each state reference to CardUI 
			# they will operate on, otherwise will be null.
			child.card_ui = card
			
	if initial_state:
		initial_state.enter()
		current_state = initial_state
		
		
func on_input(event: InputEvent) -> void:
	if current_state:
		current_state.on_input(event)


func on_gui_input(event: InputEvent) -> void:
	if current_state:
		current_state.on_gui_input(event)
		

func on_mouse_entered() -> void:
	if current_state:
		current_state.on_mouse_entered()


func on_mouse_exited() -> void:
	if current_state:
		current_state.on_mouse_exited()


func _on_transition_requested(from: CardState, to: CardState.State) -> void:
	if from != current_state:
		return
		
	var new_state: CardState = states[to]
	if not new_state:
		return
	
	if current_state:
		current_state.exit()
	
	new_state.enter()
	current_state = new_state
