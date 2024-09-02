extends Node3D


func _ready():
    var spawners: Array[Node] = get_tree().get_nodes_in_group("Enemy_Spawners")

    if spawners.size() < 1:
        return
    
    for i in range(spawners.size()):
        var spawner: EnemySpawner = spawners[i]
        var enemy_scene: Enemy = spawner.spawn_enemy()
        add_child(enemy_scene)
