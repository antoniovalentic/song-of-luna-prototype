extends Node

# GUI signals
signal gui_hidden()
signal gui_shown()
signal reload_started()
signal reload_done()

# Player signals
signal player_speed_updated(current_speed: float, current_stamina: float, max_stamina: float)

# Inventory signals
signal equiped_item(slot: InvSlot)
signal unequiped_item(slot: InvSlot)
signal slots_updated
signal drop_item(slot: InvSlot, amount: int)
#signal hold_item(slot: InvSlot, og_ui_slot: InventorySlot)
#signal release_item(ui_slot: InventorySlot)

# Item signals
signal weapon_shot(item: InvItem, weapon_type: ItemEffectWeapon.WeaponType, damage: float)
signal ammo_count_updated(capacity: int, count: int)
signal heal_player(amount: float)

func _ready():
	pass