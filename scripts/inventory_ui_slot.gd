extends Panel
class_name InventorySlot

@onready var item_sprite: Sprite2D = %ItemSprite
@onready var amount_label: Label = %AmountLabel

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
