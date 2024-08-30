extends Panel
class_name InventorySlot

enum SlotType {INVENTORY, EQUIPMENT}

@export var type: SlotType = SlotType.INVENTORY

@onready var item_sprite: Sprite2D = %ItemSprite
@onready var amount_label: Label = %AmountLabel
@onready var title_label: Label = %TitleLabel

var slot_data: InvSlot

func _gui_input(event):
	# ignore empty slots
	if self.slot_data.item == null:
		return
	
	if event is InputEventMouseButton and self.type == SlotType.INVENTORY:
		if Input.is_action_just_pressed("rm_click"):
			if slot_data != null:
				SignalBus.drop_item.emit(slot_data)
				slot_data.item = null
		elif event.double_click:
			# If item, equip; if consumable, consume
			if self.slot_data.item.item_type == InvItem.ItemType.WEAPON:
				SignalBus.equiped_item.emit(self.slot_data)
			elif self.slot_data.item.item_type == InvItem.ItemType.CONSUMABLE:
				# TODO - consume item
				pass
	if event is InputEventMouseButton and self.type == SlotType.EQUIPMENT and event.double_click:
		# Remove equiped item
		if self.slot_data.item.item_type == InvItem.ItemType.WEAPON:
			SignalBus.unequiped_item.emit(self.slot_data)
	

func update(slot: InvSlot):
	self.slot_data = slot
	update_data()
	
func update_data():
	if not self.slot_data:
		return
	if !slot_data.item:
		item_sprite.visible = false
		amount_label.visible = false
		item_sprite.texture = null
		amount_label.text = ''
		title_label.text = ''
	else:
		item_sprite.visible = true
		if slot_data.item.max_stack > 1:
			amount_label.visible = true
		else:
			amount_label.visible = false
		
		item_sprite.texture = slot_data.item.ui_sprite
		title_label.text = str(slot_data.item.name).to_upper()

		# Ammo count for weapon
		amount_label.text = str(slot_data.amount)
