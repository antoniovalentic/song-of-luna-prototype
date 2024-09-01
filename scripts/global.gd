extends Node

@onready var viewport: Viewport = get_viewport()

# Variables
var player_instance: Player = null
var game_paused: bool = false

func _ready():
	# Resolution scaling settings
	#viewport.scaling_3d_scale = 0.25
	#viewport.scaling_3d_mode = Viewport.SCALING_3D_MODE_BILINEAR
	pass

func set_player_reference(player: Player):
	player_instance = player


func toggle_pause_game():
	if !game_paused:
		game_paused = true
		SignalBus.game_paused.emit()
	else:
		game_paused = false
		SignalBus.game_unpaused.emit()
