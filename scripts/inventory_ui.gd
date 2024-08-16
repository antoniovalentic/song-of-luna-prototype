extends Control
class_name InventoryUI

@onready var inventory: Inventory = preload("res://resources/inventory/player_inventory.tres")
@onready var ui_slots = $GridContainer.get_children()

var is_open = false

func _ready():
	inventory.slots_updated.connect(update_slots)
	update_slots()
	close()

func _input(event: InputEvent):
	if event.is_action_pressed("ui_inventory"):
		if is_open:
			close()
		else:
			open()
	elif event.is_action_pressed("ui_cancel"):
		if is_open:
			close()

func update_slots():
	for i in range(min(inventory.slots.size(), ui_slots.size())):
		ui_slots[i].update(inventory.slots[i])

func close():
	visible = false
	is_open = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func open():
	visible = true
	is_open = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
