extends Resource
class_name Inventory

signal slots_updated

@export var slots: Array[InvSlot]

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