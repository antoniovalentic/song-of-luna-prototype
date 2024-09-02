extends Node3D

@onready var pause_menu: PauseMenu = $PauseMenu

func _ready():
    Global.set_current_scene(self)
    pause_menu.resume_pressed.connect(_on_resume_button_pressed)
    pause_menu.quit_pressed.connect(_on_quit_button_pressed)

    var spawners: Array[Node] = get_tree().get_nodes_in_group("Enemy_Spawners")

    if spawners.size() < 1:
        return
    
    for i in range(spawners.size()):
        var spawner: EnemySpawner = spawners[i]
        var enemy_scene: Enemy = spawner.spawn_enemy()
        add_child(enemy_scene)

func _on_resume_button_pressed():
    Global.set_pause_game(false)

func _on_quit_button_pressed():
    Global.set_pause_game(true)
    # Load main menu scene
    Global.load_scene(self, Global.main_menu_scene)

