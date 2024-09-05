extends Node3D

@onready var eye: Node3D = $MapLayout/Eye
@onready var pause_menu: PauseMenu = $PauseMenu

@onready var start_audio_player: AudioStreamPlayer = $StartAudioStreamPlayer
@onready var end_audio_player: AudioStreamPlayer = $EndAudioStreamPlayer

@onready var player_spawn_start: Node3D = $PlayerSpawnStart
@onready var player_spawn: Node3D = $HutExterior/PlayerSpawn

func _ready():
    Global.set_current_scene(self)
    eye.visible = false

    end_audio_player.stream_paused = true

    SignalBus.game_end.connect(_on_game_end)
    pause_menu.resume_pressed.connect(_on_resume_button_pressed)
    pause_menu.quit_pressed.connect(_on_quit_button_pressed)

    var enemy_spawners: Array[Node] = get_tree().get_nodes_in_group("Enemy_Spawners")
    var item_spawners: Array[Node] = get_tree().get_nodes_in_group("Item_Spawners")

    # Spawn enemies
    if enemy_spawners.size() > 0:
        for i in range(enemy_spawners.size()):
            var spawner: EnemySpawner = enemy_spawners[i]
            var enemy_scene: Enemy = spawner.spawn_enemy()
            if enemy_scene != null:
                spawner.add_child(enemy_scene)
                #enemy_scene.global_position = spawner.global_position

    # Spawn items
    if item_spawners.size() > 0:
        for i in range(item_spawners.size()):
            var spawner: ItemSpawner = item_spawners[i]
            var item_scene: ItemScene = spawner.spawn_item()
            if item_scene != null:
                spawner.add_child(item_scene)
                #item_scene.global_position = spawner.global_position
    
    # Position player if needed
    if Global.entered_hut:
        Global.get_player_reference().global_position = player_spawn.global_position

func _on_resume_button_pressed():
    Global.set_pause_game(false)

func _on_quit_button_pressed():
    Global.set_pause_game(true)
    # Load main menu scene
    Global.load_scene(self, Global.main_menu_scene)

func _on_game_end():
    start_audio_player.autoplay = false
    start_audio_player.stop()
    end_audio_player.stream_paused = false
    eye.visible = true
