extends Panel
class_name InventorySlot

enum SlotType {INVENTORY, EQUIPMENT}

@export var type: SlotType = SlotType.INVENTORY

@onready var item_sprite: Sprite2D = %ItemSprite
@onready var amount_label: Label = %AmountLabel

func _gui_input(event):
	if event is InputEventMouseButton and self.type == SlotType.INVENTORY:
		print_debug(event.double_click)

func update(slot: InvSlot):
	if !slot.item:
		item_sprite.visible = false
		amount_label.visible = false
	else:
		item_sprite.visible = true
		if slot.item.max_stack > 1:
			amount_label.visible = true
		else:
			amount_label.visible = false
		
		item_sprite.texture = slot.item.ui_sprite
		amount_label.text = str(slot.amount)
	
	# TODO - REMOVE
	# resize item sprite if needed
	if item_sprite.texture != null:
		var img: Image = item_sprite.texture.get_image()
		print_debug(img.get_width())
		if img.get_width() > 16 or img.get_height() > 16:
			print_debug(self.name)
			img.resize(16, 16, Image.INTERPOLATE_TRILINEAR)
			var newTexture = ImageTexture.create_from_image(img)
			item_sprite.texture = newTexture
