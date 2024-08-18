@tool
class_name UIViewport
extends SubViewportContainer

## The camera this viewport replicates.
@export var view_camera: Camera3D

@onready var viewport: SubViewport = $SubViewport
@onready var camera: Camera3D = $SubViewport/Camera

func _ready():
    camera.projection = view_camera.projection
    camera.size = view_camera.size
    camera.position = view_camera.position
    camera.global_transform = view_camera.global_transform

func _process(_delta: float) -> void:
    if view_camera and camera:
        # Update any properties to copy the camera exactly.
        # I don't plan on changing anything put the transform at runtime,
        # but if you have more camera properties that would change at runtime, add them below.
        camera.global_transform = view_camera.global_transform