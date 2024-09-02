extends Node
class_name Health

@onready var ui_bar: HealthUiBar = $HealthBar

var value: float
@export var max_value: float
@export var start_value: float

func _ready():
    value = start_value
    SignalBus.heal_player.connect(_on_heal_player)
    SignalBus.damage_player.connect(_on_damage_player)
    update_ui_bar()


func update_ui_bar():
    ui_bar.update_value(value, max_value)
    SignalBus.player_health_updated.emit(value, max_value)

func add(amount: float):
    value = clampf(value + amount, 0.0, max_value)
    update_ui_bar()

func subtract(amount: float):
    value = clampf(value - amount, 0.0, max_value)
    update_ui_bar()
    if value == 0.0:
        SignalBus.player_death.emit()


func _on_heal_player(item: InvItem, amount: float):
    if value < max_value:
        add(amount)
        SignalBus.item_consumed.emit(item, 1)

func _on_damage_player(amount: float):
    subtract(amount)
