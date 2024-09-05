extends Node

# Level scenes
@onready var main_menu_scene: PackedScene = load("res://main_menu.tscn")
@onready var main_scene: PackedScene = load("res://main-scene.tscn")

@onready var viewport: Viewport = get_viewport()

# Game state variables
var player_instance: Player = null
var current_scene: Node3D = null
var dead_enemies: Array[String] = []
var picked_up_items: Array[String] = []
var is_game_end: bool = false
var entered_hut: bool = false

var has_red_orb: bool = false
var has_green_orb: bool = false
var has_blue_orb: bool = false

func _ready():
	# Resolution scaling settings
	#viewport.scaling_3d_scale = 0.25
	#viewport.scaling_3d_mode = Viewport.SCALING_3D_MODE_BILINEAR

	SignalBus.enemy_killed.connect(_on_enemy_killed)
	SignalBus.item_picked.connect(_on_item_picked)
	SignalBus.game_end.connect(_on_game_end)

func reset_states():
	reset_dead_enemies()
	reset_picked_items()
	player_instance = null
	current_scene = null
	dead_enemies = []
	picked_up_items = []
	is_game_end = false
	entered_hut = false
	has_red_orb = false
	has_green_orb = false
	has_blue_orb = false

func set_player_reference(player: Player):
	player_instance = player

func get_player_reference() -> Player:
	return player_instance


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
	# Queue free all spawners first
	"""var spawners := get_tree().get_nodes_in_group("Spawners")
	for node in spawners:
		node.queue_free()"""
	
	# Load new scene instance
	var scene_instance: Node3D = scene.instantiate()
	scene_instance.request_ready()
	get_tree().root.add_child(scene_instance)
	caller.queue_free()

	# Proper window sizing
	get_tree().root.size_changed.emit()


func check_enemy_id(id: String) -> bool:
	if id in dead_enemies:
		return false
	else:
		return true

func reset_dead_enemies():
	dead_enemies.clear()

func _on_enemy_killed(id: String):
	dead_enemies.append(id)


func check_item_id(id: String) -> bool:
	if id in picked_up_items:
		return false
	else:
		return true

func reset_picked_items():
	picked_up_items.clear()

func _on_item_picked(id: String):
	picked_up_items.append(id)


func _on_game_end():
	is_game_end = true

	var callback := func():
		Global.load_scene(current_scene, main_menu_scene)
	
	var tween: Tween = get_tree().create_tween().bind_node(self).set_loops(1)
	tween.tween_callback(callback).set_delay(10)
