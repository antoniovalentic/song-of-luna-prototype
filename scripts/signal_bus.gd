extends Node

# GUI signals
signal gui_hidden()
signal gui_shown()

# Player signals
signal player_speed_updated(current_speed: float, current_stamina: float, max_stamina: float)

# Inventory signals
signal equiped_item(slot: InvSlot)
signal unequiped_item(slot: InvSlot)
signal slots_updated

func _ready():
	pass