extends CPUParticles3D


func _ready():
    SignalBus.weapon_shot.connect(_on_weapon_shot)

func _on_weapon_shot(item: InvItem, _weapon_type: ItemEffectWeapon.WeaponType, _damage: float):
    if item.item_type == InvItem.ItemType.WEAPON:
        restart()
