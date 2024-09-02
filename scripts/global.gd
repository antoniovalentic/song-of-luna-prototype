extends Node

@onready var viewport: Viewport = get_viewport()

# Variables
var player_instance: Player = null
var dead_enemies: Array[String] = []

func _ready():
	# Resolution scaling settings
	#viewport.scaling_3d_scale = 0.25
	#viewport.scaling_3d_mode = Viewport.SCALING_3D_MODE_BILINEAR

	SignalBus.enemy_killed.connect(_on_enemy_killed)


func set_player_reference(player: Player):
	player_instance = player

func get_pause_game() -> bool:
	return get_tree().paused

func set_pause_game(value: bool):
	get_tree().paused = value
	if value:
		SignalBus.game_paused.emit()
	else:
		SignalBus.game_unpaused.emit()

func load_scene(caller: Node, scene: PackedScene):
	var scene_instance: Node3D = scene.instantiate()
	get_tree().root.add_child(scene_instance)
	caller.queue_free()

func check_enemy_id(id: String) -> bool:
	if id in dead_enemies:
		return false
	else:
		return true


func _on_enemy_killed(id: String):
	dead_enemies.append(id)
	print_debug(dead_enemies)