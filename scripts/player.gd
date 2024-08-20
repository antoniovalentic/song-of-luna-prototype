extends CharacterBody3D
class_name Player

@onready var camera: Camera3D = %Camera
@onready var pivot: Node3D = %CameraPivot

@onready var interact_area: Area3D = %Camera/InteractArea
@onready var interact_raycast: RayCast3D = %Camera/InteractArea/InteractRayCast
@onready var attack_raycast: RayCast3D = %Camera/AttackRayCast

@export_category("Movement")
@export var MOVE_SPEED: float = 4.0
@export var SPRINT_SPEED: float = 7.0
@export var JUMP_FORCE: float = 5.0
@export var MAX_STAMINA: float = 100.0
@export var STAMINA_DECAY: float = 1.5
@export var STAMINA_RECOVERY: float = 0.5
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@export_category("Camera")
@export var LOOK_SENSITIVITY: float = 0.01
@export var X_ROTATION_LIMIT: float = 90.0

@export_category("Inventory")
@export var INVENTORY: Inventory

var current_speed: float = 0.0
var current_stamina: float = 0.0
var is_recovering_stamina: bool = false

func _ready():
	# Register Player node in Global script
	Global.set_player_reference(self)
	
	# Hide mouse cursor on start
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	current_stamina = MAX_STAMINA


func _input(event: InputEvent):
	if event.is_action_pressed("interact_action"):
		var interact_collider: Object = interact_raycast.get_collider()
		if interact_collider is ItemScene:
			print_debug(interact_collider.item.name)
			interact_collider.collect_item()

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		pivot.rotate_y(-event.relative.x * LOOK_SENSITIVITY)
		camera.rotate_x(-event.relative.y * LOOK_SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-X_ROTATION_LIMIT), deg_to_rad(X_ROTATION_LIMIT))

func _unhandled_key_input(event: InputEvent):
	# Show mouse cursor on Esc press
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _process(_delta: float):
	pass

func _physics_process(delta: float):
	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_FORCE
	
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction: Vector3 = (pivot.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if is_recovering_stamina and current_stamina == 100.0:
		is_recovering_stamina = false
	elif not is_recovering_stamina and current_stamina == 0.0:
		is_recovering_stamina = true

	# Calculate speed
	if Input.is_action_pressed("sprint") and is_on_floor() and not is_recovering_stamina:
		current_stamina = clamp(current_stamina - STAMINA_DECAY, 0.0, MAX_STAMINA)
		current_speed = SPRINT_SPEED
			
	else:
		current_stamina = clamp(current_stamina + STAMINA_RECOVERY, 0.0, MAX_STAMINA)
		current_speed = MOVE_SPEED
	
	SignalBus.player_speed_updated.emit(current_speed, current_stamina, MAX_STAMINA)
	velocity.x = direction.x * current_speed
	velocity.z = direction.z * current_speed
	move_and_slide()

# Inventory functions
func pick_up(item: InvItem, amount: int):
	INVENTORY.insert(item, amount)
