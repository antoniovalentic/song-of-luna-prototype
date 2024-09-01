extends Area3D
class_name PlayerHitBox

var enemies_in_range: Array[EnemyHurtBox] = []


func _ready():
    pass


func _on_area_entered(area: Area3D):
    if area is EnemyHurtBox:
        enemies_in_range.push_front(area)

func _on_area_exited(area: Area3D):
    if area is EnemyHurtBox:
        var index: int = enemies_in_range.find(area)
        if index >= 0:
            enemies_in_range.remove_at(index)
