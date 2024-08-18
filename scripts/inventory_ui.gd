extends Control
class_name InventoryUI

@onready var inventory: Inventory = preload("res://resources/inventory/player_inventory.tres")
@onready var ui_slots = $GridContainer.get_children()

func _ready():
	inventory.slots_updated.connect(update_slots)
	update_slots()

func update_slots():
	for i in range(min(inventory.slots.size(), ui_slots.size())):
		ui_slots[i].update(inventory.slots[i])

