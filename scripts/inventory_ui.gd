extends NinePatchRect
class_name InventoryUI

@onready var inventory: Inventory = preload("res://resources/inventory/player_inventory.tres")
@onready var equip_slot: InventorySlot = $EquipmentSlot
@onready var ui_slots = $GridContainer.get_children()


func _ready():
	update_slots()
	inventory.slots_updated.connect(update_slots)
	SignalBus.equiped_item.connect(_on_equiped_item)

func update_slots():
	equip_slot.update(inventory.equiped_item)
	for i in range(min(inventory.slots.size(), ui_slots.size())):
		ui_slots[i].update(inventory.slots[i])


func _on_equiped_item(slot: InvSlot):
	inventory.equip(slot.item)
	update_slots()