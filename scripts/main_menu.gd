extends Node3D

@onready var pause_menu: PauseMenu = $PauseMenu

@onready var main_scene: PackedScene = preload("res://main-scene.tscn")

func _ready():
    Global.set_pause_game(true)
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
    pause_menu.resume_pressed.connect(_on_resume_button_pressed)
    pause_menu.quit_pressed.connect(_on_quit_button_pressed)

func _on_resume_button_pressed():
    Global.set_pause_game(false)
    # Load main level
    Global.load_scene(self, main_scene)

func _on_quit_button_pressed():
    get_tree().quit() 

