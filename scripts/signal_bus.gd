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
signal drop_item(slot: InvSlot)
#signal hold_item(slot: InvSlot, og_ui_slot: InventorySlot)
#signal release_item(ui_slot: InventorySlot)

# Item signals
signal item_shot(item: InvItem, damage: float)
signal heal_player(amount: float)

func _ready():
	pass