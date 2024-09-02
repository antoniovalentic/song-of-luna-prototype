extends Node

# Level scenes
@onready var main_menu_scene: PackedScene = preload("res://main_menu.tscn")
@onready var main_scene: PackedScene = preload("res://main-scene.tscn")

@onready var viewport: Viewport = get_viewport()

# Variables
var player_instance: Player = null
var current_scene: Node3D = null
var dead_enemies: Array[String] = []

func _ready():
	# Resolution scaling settings
	#viewport.scaling_3d_scale = 0.25
	#viewport.scaling_3d_mode = Viewport.SCALING_3D_MODE_BILINEAR

	SignalBus.enemy_killed.connect(_on_enemy_killed)


func set_player_reference(player: Player):
	player_instance = player

func set_current_scene(scene: Node3D):
	current_scene = scene

func get_current_scene() -> Node3D:
	return current_scene

func get_pause_game() -> bool:
	return get_tree().paused

func set_pause_game(value: bool):
	get_tree().paused = value
	if value:
		SignalBus.game_paused.emit()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		SignalBus.game_unpaused.emit()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func load_scene(caller: Node, scene: PackedScene):
	var scene_instance: Node3D = scene.instantiate()
	get_tree().root.add_child(scene_instance)
	caller.queue_free()


func check_enemy_id(id: String) -> bool:
	if id in dead_enemies:
		return false
	else:
		return true

func reset_dead_enemies():
	dead_enemies.clear()


func _on_enemy_killed(id: String):
	dead_enemies.append(id)
