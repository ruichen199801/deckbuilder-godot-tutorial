class_name Battle
extends Node2D

# This is the main / only one place where we need to provide char_stats,
# to distribute to other scenes.
#                      Battle
#                 /      |      \       
#             Player   BattleUI  PlayerHandler
#                      /     \
#                    Hand     ManaUI
#                     |
#                    CardUI1
#                    CardUI2
# In our design, we export char_stats in each individual scenes as well so that
# they are self-contained and can be tested in isolation.
# But for the game to run, we only need to export in battle scene.
@export var char_stats: CharacterStats
@export var music: AudioStream

@onready var battle_ui: BattleUI = $BattleUI
@onready var player_handler: PlayerHandler = $PlayerHandler
@onready var enemy_handler: EnemyHandler = $EnemyHandler
@onready var player: Player = $Player


func _ready() -> void:
	# Temporary code: normally, we would do this on a 'Run' level so we keep our health,
	# gold and deck between battles.
	var new_stats: CharacterStats = char_stats.create_instance()
	battle_ui.char_stats = new_stats
	player.stats = new_stats
	
	enemy_handler.child_order_changed.connect(_on_enemies_child_order_changed)
	Events.enemy_turn_ended.connect(_on_enemy_turn_ended)
	
	# Flow: scene load -> start_battle -> play cards -> end_turn -> start_turn -> repeat
	Events.player_turn_ended.connect(player_handler.end_turn)
	Events.player_hand_discarded.connect(enemy_handler.start_turn)
	Events.player_died.connect(_on_player_died)
	
	start_battle(new_stats)
	
	
func start_battle(stats: CharacterStats) -> void:
	get_tree().paused = false
	MusicPlayer.play(music, true)
	enemy_handler.reset_enemy_actions()
	player_handler.start_battle(stats)
	
	
func _on_enemies_child_order_changed() -> void:
	if enemy_handler.get_child_count() == 0:
		Events.battle_over_screen_requested.emit("Victorious!", BattleOverPanel.Type.WIN)


func _on_enemy_turn_ended() -> void:
	player_handler.start_turn()
	enemy_handler.reset_enemy_actions()
	
	
func _on_player_died() -> void:
	Events.battle_over_screen_requested.emit("Game Over!", BattleOverPanel.Type.LOSE)
