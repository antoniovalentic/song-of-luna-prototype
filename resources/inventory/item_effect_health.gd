extends ItemEffect
class_name ItemEffectHealth

@export var amount: float = 20.0

func activate(item: InvItem):
    SignalBus.heal_player.emit(item, amount)


func deactivate(item: InvItem):
    pass
