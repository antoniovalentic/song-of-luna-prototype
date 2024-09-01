extends Area3D
class_name EnemyHurtBox

signal damage_recieved(damage: float)
signal flare_recieved()

@export_range(0.0, 2.0, 0.1) var damage_modifier: float = 1.0


func recieve_damage(damage: float):
    damage_recieved.emit(damage * damage_modifier)

func recieve_flare():
    flare_recieved.emit()