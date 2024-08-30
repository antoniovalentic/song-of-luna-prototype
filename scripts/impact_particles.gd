extends Node3D

@onready var particle_emmiter: CPUParticles3D = $CPUParticles3D

func _ready():
    particle_emmiter.restart()


func _process(delta):
    if particle_emmiter.emitting == false:
        queue_free()