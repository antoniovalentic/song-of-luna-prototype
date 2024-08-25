extends Node

# Player signals
signal player_speed_updated(current_speed: float, current_stamina: float, max_stamina: float)

signal inventory_updated(new_inventory: Array[Dictionary], new_item: Dictionary)

signal equiped_item(slot: InvSlot)

func _ready():
	pass