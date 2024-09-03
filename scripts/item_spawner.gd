extends Node3D
class_name ItemSpawner

signal item_spawned(spawner: ItemSpawner, itemScene: Node3D)

@export var item_id: String
@export var item_scene: PackedScene


func spawn_item():
    if item_id and item_scene and Global.check_item_id(item_id):
        var item_instance: Node3D = item_scene.instantiate()
        item_instance.global_position = self.global_position
        item_instance.item_id = item_id
        item_spawned.emit(self, item_instance)
        return item_instance