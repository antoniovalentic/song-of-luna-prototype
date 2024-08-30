extends ItemEffect
class_name ItemEffectWeapon

enum WeaponType {MEELE, RANGED}

@export var weapon_type: WeaponType
@export var damage: float

@export_category("Ranged weapon stats")
@export var ammo_amount: int = 0
@export_range(0, 6) var mag_amount: int = 6
@export var mag_capacity: int = 6

func activate(item: InvItem):
    if weapon_type == WeaponType.MEELE:
        SignalBus.weapon_shot.emit(item, weapon_type, damage)
    elif weapon_type == WeaponType.RANGED:
        if mag_amount > 0:
            mag_amount -= 1
            SignalBus.weapon_shot.emit(item, weapon_type, damage)
            SignalBus.ammo_count_updated.emit(mag_capacity, mag_amount)

func deactivate(item: InvItem):
    pass

func reload():
    mag_amount = mag_capacity
    SignalBus.ammo_count_updated.emit(mag_capacity, mag_amount)