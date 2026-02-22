class_name EnemyAction
extends Node

# Enemy Actions
# 1. Conditional
#   - prioritized over chance-based actions
#   - provides a can_perform() method to decide if the condition is met
#   - e.g. performed on first turn, under 30% hp, etc.
# 2. Chance-Based
#   - has a chance of happening if no conditional actions can be performed
#   - if there are multiple chance-based actions available, one is selected randomly
#   - Weighted randomness reference: http://kehomsforge.com/tutorials/single/weighted-random-selection-godot/
enum Type {CONDITIONAL, CHANCE_BASED}

@export var intent: Intent
@export var sound: AudioStream
@export var type: Type
# Only set in Inspector for Chance-Based enemy actions
# Can be arbitrary scale, e.g. for 2 actions with 50/50 chance,
# you can set both to 1, or set both to 0.5, as long as they are equal.
@export_range(0.0, 10.0) var chance_weight := 0.0

@onready var accumulated_weight := 0.0

var enemy: Enemy
var target: Node2D


# For conditional check only, default to false to be safe
func is_performable() -> bool:
	return false


func perform_action() -> void:
	pass
