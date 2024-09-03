extends CharacterBody3D
class_name Enemy

@export_category("Stats")
@export var DAMAGE: float = 15.0
@export var HEALTH: float = 50.0
@export var MAX_HEALTH: float = 50.0

@export_category("Death")
@export_range(0, 60, 0.5) var MIN_SLEEP: float = 15.0
@export_range(0, 60, 0.5) var MAX_SLEEP: float = 50.0

@export_category("Movement")
@export var MAX_SPEED: float = 5.0
@export var HURT_SPEED: float = 2.0

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var hurt_box: EnemyHurtBox = $HurtBox
@onready var hit_box: Area3D = $HitBox
@onready var fake_death_timer: Timer = $FakeDeathTimer
@onready var real_death_timer: Timer = $RealDeathTimer
@onready var speed_recovery_timer: Timer = $SpeedRecoveryTimer
@onready var hit_recovery_timer: Timer = $HitRecoveryTimer
@onready var flame_particles: CPUParticles3D = $ParticleRoot/FlameParticles
@onready var blood_particles: CPUParticles3D = $ParticleRoot/BloodParticles

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

var is_fake_dead: bool = false
var is_burning: bool = false
var player: Player = null
var speed: float = 0.0
var player_detected: bool = false
var player_in_hit_range: bool = false
var is_hit_recovering: bool = false
var enemy_id: String = ''

func _ready():
    self.is_fake_dead = false
    self.player = Global.get_player_reference()
    self.speed = MAX_SPEED
    hurt_box.damage_recieved.connect(_on_damage_recieved)
    hurt_box.flare_recieved.connect(_on_flare_recieved)

    # These values need to be adjusted for the actor's speed
    # and the navigation layout.
    navigation_agent.path_desired_distance = 0.5
    navigation_agent.target_desired_distance = 0.5

    # Make sure to not await during _ready.
    call_deferred("actor_setup")

func actor_setup():
    # Wait for the first physics frame so the NavigationServer can sync.
    await get_tree().physics_frame

    # Now that the navigation map is no longer empty, set the movement target.
    set_movement_target(player.global_position)

func set_movement_target(movement_target: Vector3):
    navigation_agent.set_target_position(movement_target)

func _physics_process(delta: float):
    # Gravity
    if not is_on_floor():
        velocity.y -= gravity * delta
    
    if navigation_agent.is_navigation_finished() or not player_detected:
        return
    
    if not is_fake_dead and player != null:
        """var velocity_dir: Vector3 = global_position.direction_to(player.global_position)
        move_and_collide(velocity_dir * speed * delta)"""
        set_movement_target(player.global_position)
        look_at(player.global_position)
        rotate_y(deg_to_rad(90))
        var current_agent_position: Vector3 = global_position
        var next_path_position: Vector3 = navigation_agent.get_next_path_position()
        velocity = current_agent_position.direction_to(next_path_position) * speed
        move_and_slide()

func real_death():
    if is_fake_dead:
        SignalBus.enemy_killed.emit(enemy_id)
        self.queue_free()
    else:
        fake_death()

func start_real_death_timer():
    real_death_timer.wait_time = randf_range(5.0, 10.0)
    real_death_timer.start()

func fake_death():
    if not is_fake_dead:
        is_fake_dead = true

        # rotate_z(deg_to_rad(90.0))
        var tween: Tween = get_tree().create_tween().bind_node(self)
        tween.tween_property(self, "rotation:x", deg_to_rad(90.0), 0.35).as_relative().set_trans(Tween.TRANS_SINE)

        if not is_burning:
            fake_death_timer.wait_time = randf_range(MIN_SLEEP, MAX_SLEEP)
            fake_death_timer.start()
        else:
            start_real_death_timer()

func damage_enemy(damage: float):
    HEALTH -= damage
    if HEALTH <= 0:
        HEALTH = 0
        fake_death()

func _on_damage_recieved(damage: float):
    speed = HURT_SPEED
    speed_recovery_timer.start()
    blood_particles.restart()
    damage_enemy(damage)

func _on_flare_recieved():
    if not is_burning:
        is_burning = true
        flame_particles.emitting = true
        start_real_death_timer()
        if is_fake_dead:
            fake_death_timer.stop()

func _on_fake_timer_timeout():
    if is_burning:
        real_death()
    elif is_fake_dead:
        is_fake_dead = false
        HEALTH = MAX_HEALTH / 2.0
        # rotate_z(deg_to_rad(-90.0))
        var tween: Tween = get_tree().create_tween().bind_node(self)
        tween.tween_property(self, "rotation:x", deg_to_rad(-90.0), 0.35).as_relative().set_trans(Tween.TRANS_SINE)

func _on_real_timer_timeout():
    if is_fake_dead:
        real_death()
    else:
        damage_enemy(MAX_HEALTH / 2.0)
        start_real_death_timer()

func _on_speed_recovery_timer_timeout():
    speed = MAX_SPEED

func _on_hit_recovery_timer_timeout():
    if player_in_hit_range and not is_fake_dead:
        SignalBus.damage_player.emit(DAMAGE)
        hit_recovery_timer.start()
    else:
        is_hit_recovering = false


func _on_detection_area_body_exited(body: Node3D):
    if body is Player:
        player_detected = false

func _on_detection_area_body_entered(body: Node3D):
    if body is Player:
        player_detected = true

func _on_hit_box_body_entered(body: Node3D):
    if body is Player:
        player_in_hit_range = true
        if not is_hit_recovering and not is_fake_dead:
            SignalBus.damage_player.emit(DAMAGE)
            hit_recovery_timer.start()

func _on_hit_box_body_exited(body: Node3D):
    if body is Player:
        player_in_hit_range = false
