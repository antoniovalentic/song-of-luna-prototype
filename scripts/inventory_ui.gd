extends Control
class_name InventoryUI

@onready var inventory: Inventory = preload("res://resources/inventory/player_inventory.tres")
@onready var equip_slot: InventorySlot = $StatusContainer/EquipmentSlot
@onready var ui_slots = $GridContainer.get_children()


func _ready():
	if inventory.equiped_item.item == null:
		inventory.equip(inventory.default_equip_item.item)
	update_slots()
	SignalBus.slots_updated.connect(update_slots)
	SignalBus.equiped_item.connect(_on_equiped_item)
	SignalBus.unequiped_item.connect(_on_unequiped_item)

func update_slots():
	equip_slot.update(inventory.equiped_item)
	for i in range(min(inventory.slots.size(), ui_slots.size())):
		ui_slots[i].update(inventory.slots[i])


func _on_equiped_item(slot: InvSlot):
	inventory.equip(slot.item)
	update_slots()

func _on_unequiped_item(slot: InvSlot):
	inventory.unequip(slot.item)
	update_slots()
