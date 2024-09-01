extends ItemEffect
class_name ItemEffectFlare


func activate(item: InvItem):
    SignalBus.weapon_shot.emit(item, ItemEffectWeapon.WeaponType.MEELE, 0.0)


func deactivate(item: InvItem):
    pass
