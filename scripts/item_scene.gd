extends Area3D
class_name ItemScene

@export var item: InvItem
@export_range(1, 99, 1) var amount: int = 1

@onready var mesh: MeshInstance3D = $Mesh
@onready var mesh_outline: MeshInstance3D = $MeshOutline
@onready var player = Global.get_player_reference()

var player_in_range: bool = false
var item_id: String = ''

func _ready():
    add_to_group("Items")
    mesh_outline.visible = false
    item.scene_path = self.scene_file_path

func _unhandled_input(_event: InputEvent):
    if Input.is_action_just_pressed("lm_click") and item.effect != null and player != null:
        # Check if item equiped
        if player.INVENTORY.equiped_item.item == item:
            item.effect.activate(item)


func _area_entered_area(area: Area3D):
    if area.is_in_group("Player_GrabArea"):
        player_in_range = true
    elif area.is_in_group("Player_InteractArea"):
        mesh_outline.visible = true

func _area_exited_area(area: Area3D):
    if area.is_in_group("Player_GrabArea"):
        player_in_range = false
    elif area.is_in_group("Player_InteractArea"):
        mesh_outline.visible = false


func collect_item():
    if player_in_range:
        player.pick_up(item, amount)
        SignalBus.item_picked.emit(item_id)
        self.queue_free()
