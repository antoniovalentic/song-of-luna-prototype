extends Node
class_name Health

@onready var ui_bar: HealthUiBar = $HealthBar

var value: float
@export var max_value: float
@export var start_value: float

func _ready():
    value = start_value
    ui_bar.update_value(value, max_value)
    SignalBus.heal_player.connect(_on_heal_player)
    SignalBus.damage_player.connect(_on_damage_player)


func update_ui_bar():
    if ui_bar:
        ui_bar.update_value(value, max_value)

func add(amount: float):
    value = clampf(value + amount, 0.0, max_value)
    update_ui_bar()

func subtract(amount: float):
    value = clampf(value - amount, 0.0, max_value)
    update_ui_bar()


func _on_heal_player(item: InvItem, amount: float):
    if value < max_value:
        add(amount)
        SignalBus.item_consumed.emit(item, 1)

func _on_damage_player(_item: InvItem, amount: float):
    subtract(amount)
