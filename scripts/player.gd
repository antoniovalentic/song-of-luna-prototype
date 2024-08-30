extends CharacterBody3D
class_name Player

@onready var camera: Camera3D = %Camera
@onready var pivot: Node3D = %CameraPivot

@onready var interact_area: Area3D = %Camera/InteractArea
@onready var interact_raycast: RayCast3D = %Camera/InteractArea/InteractRayCast
@onready var attack_raycast: RayCast3D = %Camera/AttackRayCast
@onready var weapon_node: Node3D = %Camera/WeaponNode
@onready var drop_zone: Node3D = %DropZone

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

@export_category("Level")
@export var CURRENT_LEVEL_SCENE: Node3D

var current_speed: float = 0.0
var current_stamina: float = 0.0
var is_recovering_stamina: bool = false

func _ready():
	# Register Player node in Global script
	Global.set_player_reference(self)
	
	# Hide mouse cursor on start
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	# Connect signals
	SignalBus.equiped_item.connect(_on_item_equip)
	SignalBus.unequiped_item.connect(_on_item_unequip)
	SignalBus.drop_item.connect(_on_drop_item)
	SignalBus.weapon_shot.connect(_on_weapon_shot)
	SignalBus.reload_done.connect(_on_reload_done)

	current_stamina = MAX_STAMINA


func _input(event: InputEvent):
	if event.is_action_pressed("interact_action"):
		var interact_collider: Object = interact_raycast.get_collider()
		if interact_collider is ItemScene:
			interact_collider.collect_item()

func _unhandled_input(event: InputEvent):
	# Rotate camera
	if event is InputEventMouseMotion:
		pivot.rotate_y(-event.relative.x * LOOK_SENSITIVITY)
		camera.rotate_x(-event.relative.y * LOOK_SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-X_ROTATION_LIMIT), deg_to_rad(X_ROTATION_LIMIT))
	
	# Reload
	if event.is_action_pressed("reload"):
		var equiped_item: InvItem = INVENTORY.equiped_item.item
		if equiped_item.effect != null and equiped_item.effect is ItemEffectWeapon and equiped_item.effect.weapon_type == ItemEffectWeapon.WeaponType.RANGED:
			SignalBus.reload_started.emit()

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

func _on_item_equip(slot: InvSlot):
	if slot.item.item_type == InvItem.ItemType.WEAPON and slot.item.scene_path != null:
		var weapon_scene: PackedScene = load(slot.item.scene_path)
		weapon_node.add_child(weapon_scene.instantiate())

func _on_item_unequip(_slot: InvSlot):
	var nodes: Array[Node] = weapon_node.get_children()
	for node in nodes:
		node.queue_free()

func _on_drop_item(slot: InvSlot):
	if slot.item.scene_path != null:
		var item_packed: PackedScene = load(slot.item.scene_path)
		var item_scene: Node3D = item_packed.instantiate()
		
		# Convert local positions
		item_scene.position = CURRENT_LEVEL_SCENE.to_local(pivot.to_global(drop_zone.position))
		item_scene.rotation = pivot.rotation
		item_scene.rotation.y -= deg_to_rad(180)

		CURRENT_LEVEL_SCENE.add_child(item_scene)
		INVENTORY.remove(slot.item, slot.amount)

func _on_weapon_shot(item: InvItem, _weapon_type: ItemEffectWeapon.WeaponType, damage: float):
	if item.item_type == InvItem.ItemType.WEAPON:
		var attack_collider: Object = attack_raycast.get_collider()
		if attack_collider is EnemyHurtBox:
			attack_collider.recieve_damage(damage)

func _on_reload_done():
	var equiped_item: InvItem = INVENTORY.equiped_item.item
	if equiped_item.effect != null and equiped_item.effect is ItemEffectWeapon and equiped_item.effect.weapon_type == ItemEffectWeapon.WeaponType.RANGED:
		var effect: ItemEffectWeapon = equiped_item.effect
		effect.reload()
