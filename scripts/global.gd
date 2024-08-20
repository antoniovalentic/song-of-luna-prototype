extends Node

@onready var viewport: Viewport = get_viewport()

# Variables
var player_instance: Player = null

func _ready():
	# Resolution scaling settings
	#viewport.scaling_3d_scale = 0.25
	#viewport.scaling_3d_mode = Viewport.SCALING_3D_MODE_BILINEAR
	pass

func set_player_reference(player: Player):
	player_instance = player

