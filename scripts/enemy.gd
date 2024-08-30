extends CharacterBody3D
class_name Enemy

@export_category("Stats")
@export var DAMAGE: float = 15.0
@export var HEALTH: float = 50.0

@export_category("Movement")
@export var SPEED: float = 5.0

@onready var hurt_box: EnemyHurtBox = $HurtBox

var is_fake_dead: bool = false

func _ready():
    self.is_fake_dead = false
    hurt_box.damage_recieved.connect(_on_damage_recieved)

func _physics_process(_delta: float) -> void:
    # Get the input direction and handle the movement/deceleration.
    # As good practice, you should replace UI actions with custom gameplay actions.
    var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
    if direction:
        velocity.x = direction.x * SPEED
        velocity.z = direction.z * SPEED
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)
        velocity.z = move_toward(velocity.z, 0, SPEED)

    move_and_slide()


func fake_death():
    is_fake_dead = true
    self.queue_free()

func damage_enemy(damage: float):
    HEALTH -= damage
    if HEALTH <= 0:
        HEALTH = 0
        fake_death()

func _on_damage_recieved(damage: float):
    damage_enemy(damage)

