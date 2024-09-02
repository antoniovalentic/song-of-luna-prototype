extends Node3D
class_name EnemySpawner

signal enemy_spawned(spawner: EnemySpawner, enemyScene: Node3D)

@export var enemy_id: String
@export var enemy_scene: PackedScene


func spawn_enemy():
    if enemy_id and enemy_scene and Global.check_enemy_id(enemy_id):
        var enemy_instance: Node3D = enemy_scene.instantiate()
        enemy_instance.global_position = self.global_position
        enemy_instance.enemy_id = enemy_id
        enemy_spawned.emit(self, enemy_instance)
        return enemy_instance