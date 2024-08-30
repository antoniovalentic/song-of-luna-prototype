extends Resource
class_name InvItem

enum ItemType {CONSUMABLE, USABLE, WEAPON, AMMO}

@export var name: String
@export var description: String
@export var item_type: ItemType
@export var max_stack: int = 1
@export var is_usable: bool = true

@export var ui_sprite: Texture2D

@export var scene_path: String

@export var effect: ItemEffect