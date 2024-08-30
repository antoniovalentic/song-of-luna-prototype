extends Control

@onready var magazine_label: Label = $MagazineLabel

const FORMAT_LABEL_TEXT: String = "Magazine: %s/%s"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    visible = false
    SignalBus.ammo_count_updated.connect(_on_ammo_count_updated)
    SignalBus.equiped_item.connect(_on_equiped_item)
    SignalBus.unequiped_item.connect(_on_equiped_item)

func _on_equiped_item(slot: InvSlot):
    if slot.item.effect != null and slot.item.effect is ItemEffectWeapon and slot.item.effect.weapon_type == ItemEffectWeapon.WeaponType.RANGED:
        visible = true
    else:
        visible = false

func _on_ammo_count_updated(capacity: int, count: int):
    magazine_label.text = FORMAT_LABEL_TEXT % [count, capacity]
