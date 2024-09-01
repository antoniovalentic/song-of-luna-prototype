extends CPUParticles3D


func _ready():
    SignalBus.equiped_item.connect(_on_equiped_item)
    SignalBus.unequiped_item.connect(_on_unequiped_item)


func _on_equiped_item(slot: InvSlot):
    if slot.item.effect != null and slot.item.effect is ItemEffectFlare:
        emitting = true

func _on_unequiped_item(slot: InvSlot):
    if slot.item.effect != null and slot.item.effect is ItemEffectFlare:
        emitting = false