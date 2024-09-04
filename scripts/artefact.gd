extends Node3D

@onready var interact_area: Area3D = $InteractArea

@onready var ball_red: MeshInstance3D = %Ball1
@onready var ball_green: MeshInstance3D = %Ball2
@onready var ball_blue: MeshInstance3D = %Ball3

@export var red_orb_item: InvItem
@export var green_orb_item: InvItem
@export var blue_orb_item: InvItem

var player_in_range: bool = false
var interacatable: bool = false

var player: Player = null

func _ready():
    ball_red.visible = Global.has_red_orb
    ball_green.visible = Global.has_green_orb
    ball_blue.visible = Global.has_blue_orb
    player = Global.get_player_reference()

func _input(event: InputEvent):
    if event.is_action_pressed("interact_action") and player_in_range and interacatable:
        if player.INVENTORY.check_item(red_orb_item):
            ball_red.visible = true
            SignalBus.remove_item.emit(red_orb_item)
            Global.has_red_orb = true
        if player.INVENTORY.check_item(green_orb_item):
            ball_green.visible = true
            SignalBus.remove_item.emit(green_orb_item)
            Global.has_green_orb = true
        if player.INVENTORY.check_item(blue_orb_item):
            ball_blue.visible = true
            SignalBus.remove_item.emit(blue_orb_item)
            Global.has_blue_orb = true
    
    if ball_red.visible and ball_green.visible and ball_blue.visible:
        SignalBus.game_end.emit()


func _area_entered_area(area: Area3D):
    if area.is_in_group("Player_GrabArea"):
        player_in_range = true
    elif area.is_in_group("Player_InteractArea"):
        interacatable = true

func _area_exited_area(area: Area3D):
    if area.is_in_group("Player_GrabArea"):
        player_in_range = false
    elif area.is_in_group("Player_InteractArea"):
        interacatable = false