extends Node

# Player signals
signal player_speed_updated(current_speed: float, current_stamina: float, max_stamina: float)

signal inventory_updated(new_inventory: Array[Dictionary], new_item: Dictionary)

func _ready():
	# Resolution scaling settings
	#viewport.scaling_3d_scale = 0.25
	#viewport.scaling_3d_mode = Viewport.SCALING_3D_MODE_BILINEAR
	pass