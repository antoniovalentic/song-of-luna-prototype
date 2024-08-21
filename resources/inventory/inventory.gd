extends Resource
class_name Inventory

signal slots_updated

@export var slots: Array[InvSlot]
@export var equiped_item: InvSlot

func _ready():
    equiped_item.amount = 0

func equip(item: InvItem):
    if item.item_type == InvItem.ItemType.WEAPON:
        equiped_item.item = item

func insert(item: InvItem, amount: int):
    var item_slots: Array[InvSlot] = slots.filter(func(slot): return slot.item == item)
    if !item_slots.is_empty():
        item_slots[0].amount += amount
    else:
        var empty_slots: Array[InvSlot] = slots.filter(func(slot): return slot.item == null)
        if !empty_slots.is_empty():
            empty_slots[0].item = item
            empty_slots[0].amount = amount
    
    slots_updated.emit()