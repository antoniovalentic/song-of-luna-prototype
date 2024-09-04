extends Resource
class_name Inventory

#signal slots_updated

@export var slots: Array[InvSlot]
@export var equiped_item: InvSlot
@export var default_equip_item: InvSlot

func equip(item: InvItem):
    if item.item_type == InvItem.ItemType.WEAPON:
        if equiped_item.item != null and Global.get_player_reference() != null:
            Global.player_instance._on_item_unequip(equiped_item)
            equiped_item.item = default_equip_item.item
        #if equiped_item.item != null and equiped_item.item != default_equip_item.item:
            #unequip(equiped_item.item)
        # Set new equiped item
        equiped_item.item = item
        SignalBus.slots_updated.emit()

func unequip(item: InvItem):
    if item.item_type == InvItem.ItemType.WEAPON:
        equip(default_equip_item.item)

func insert(item: InvItem, amount: int):
    # Array of slots that contain the item
    var item_slots: Array[InvSlot] = slots.filter(func(slot): return slot.item == item)
    if !item_slots.is_empty():
        item_slots[0].amount += amount
    else:
        # Get first empty slot
        var empty_slots: Array[InvSlot] = slots.filter(func(slot): return slot.item == null)
        if !empty_slots.is_empty():
            empty_slots[0].item = item
            empty_slots[0].amount = amount
    
    SignalBus.slots_updated.emit()

func remove(item: InvItem, amount: int):
    # Check if item equiped
    if equiped_item.item == item:
        unequip(item)
    # Array of slots that contain the item
    var item_slots: Array[InvSlot] = slots.filter(func(slot): return slot.item == item)
    if !item_slots.is_empty():
        item_slots[0].amount -= amount
        if item_slots[0].amount <= 0:
            item_slots[0].item = null
            item_slots[0].amount = 0
    
    SignalBus.slots_updated.emit()

func check_free_space(item: InvItem) -> bool:
    # Array of slots that contain the item
    var item_slots: Array[InvSlot] = slots.filter(func(slot): return slot.item == item)
    if !item_slots.is_empty():
        return true
    else:
        # Get first empty slot
        var empty_slots: Array[InvSlot] = slots.filter(func(slot): return slot.item == null)
        if !empty_slots.is_empty():
            return true
        else:
            return false

func check_item(item: InvItem) -> bool:
    if item == null:
        return false
    
    var item_slots: Array[InvSlot] = slots.filter(func(slot): return slot.item == item)
    if !item_slots.is_empty():
        return true
    else:
       return false

func check_item_name(name: String) -> bool:
    if name == null:
        return false
    
    var item_slots: Array[InvSlot] = slots.filter(func(slot): return slot.item.name == name)
    if !item_slots.is_empty():
        return true
    else:
       return false
