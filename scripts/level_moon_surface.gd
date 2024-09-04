extends Node3D

@onready var eye: Node3D = $MapLayout/Eye
@onready var pause_menu: PauseMenu = $PauseMenu

func _ready():
    Global.set_current_scene(self)
    eye.visible = false

    SignalBus.game_end.connect(_on_game_end)
    pause_menu.resume_pressed.connect(_on_resume_button_pressed)
    pause_menu.quit_pressed.connect(_on_quit_button_pressed)

    var enemy_spawners: Array[Node] = get_tree().get_nodes_in_group("Enemy_Spawners")
    var item_spawners: Array[Node] = get_tree().get_nodes_in_group("Item_Spawners")

    # Spawn enemies
    if enemy_spawners.size() < 1:
        return
    for i in range(enemy_spawners.size()):
        var spawner: EnemySpawner = enemy_spawners[i]
        var enemy_scene: Enemy = spawner.spawn_enemy()
        if enemy_scene != null:
            add_child(enemy_scene)
            enemy_scene.global_position = spawner.global_position

    # Spawn items
    if item_spawners.size() < 1:
        return
    for i in range(item_spawners.size()):
        var spawner: ItemSpawner = item_spawners[i]
        var item_scene: ItemScene = spawner.spawn_item()
        if item_scene != null:
            add_child(item_scene)
            item_scene.global_position = spawner.global_position

func _on_resume_button_pressed():
    Global.set_pause_game(false)

func _on_quit_button_pressed():
    Global.set_pause_game(true)
    # Load main menu scene
    Global.load_scene(self, Global.main_menu_scene)

func _on_game_end():
    eye.visible = true
