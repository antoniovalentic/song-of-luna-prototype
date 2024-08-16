extends Node

# Variables
var player_instance: Player = null

# Custom signals
signal inventory_updated(new_inventory: Array[Dictionary], new_item: Dictionary)

func _ready():
	# Initial inventory size
	pass
	#inventory.resize(INIT_INVENTORY_SIZE)

func set_player_reference(player: Player):
	player_instance = player

