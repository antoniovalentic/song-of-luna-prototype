extends Node3D

@onready var pause_menu: PauseMenu = $PauseMenu

func _ready():
    Global.set_current_scene(self)
    Global.set_pause_game(true)
    Global.reset_dead_enemies()
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
    pause_menu.resume_pressed.connect(_on_resume_button_pressed)
    pause_menu.quit_pressed.connect(_on_quit_button_pressed)

func _on_resume_button_pressed():
    Global.set_pause_game(false)
    # Load main level
    Global.load_scene(self, Global.main_scene)

func _on_quit_button_pressed():
    get_tree().quit() 

