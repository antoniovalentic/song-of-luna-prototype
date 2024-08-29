extends ItemEffect
class_name ItemEffectPGT

@export var damage: float

func activate(item: InvItem):
    SignalBus.item_shot.emit(item, damage)

func deactivate(item: InvItem):
    pass