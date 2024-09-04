extends Node3D
class_name HutDoorInterior

@onready var cylinder_outline: MeshInstance3D = $CylinderOutline
@onready var interact_area: Area3D = $Area3D

var player_in_range: bool = false

func _ready():
	cylinder_outline.visible = false


func _input(event: InputEvent):
	if event.is_action_pressed("interact_action") and player_in_range and cylinder_outline.visible:
		Global.load_scene(Global.get_current_scene(), Global.main_scene)


func _area_entered_area(area: Area3D):
	if area.is_in_group("Player_GrabArea"):
		player_in_range = true
	elif area.is_in_group("Player_InteractArea"):
		cylinder_outline.visible = true

func _area_exited_area(area: Area3D):
	if area.is_in_group("Player_GrabArea"):
		player_in_range = false
	elif area.is_in_group("Player_InteractArea"):
		cylinder_outline.visible = false
