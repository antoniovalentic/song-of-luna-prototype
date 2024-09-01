extends Node3D

@onready var pause_menu: PauseMenu = $PauseMenu

@onready var main_scene: PackedScene = preload("res://main-scene.tscn")

func _ready():
    get_tree().paused = true
    Global.toggle_pause_game()
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
    pause_menu.resume_pressed.connect(_on_resume_button_pressed)
    pause_menu.quit_pressed.connect(_on_quit_button_pressed)

func _on_resume_button_pressed():
    # Load main level
    var main_scene_instance: Node3D = main_scene.instantiate()
    get_tree().root.add_child(main_scene_instance)
    
    get_tree().paused = false
    Global.toggle_pause_game()
    self.queue_free()

func _on_quit_button_pressed():
    get_tree().quit() 

