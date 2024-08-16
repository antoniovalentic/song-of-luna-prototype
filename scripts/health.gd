extends Node
class_name Health

@onready var ui_bar: HealthUiBar = $HealthBar

var value: float
@export var max_value: float
@export var start_value: float

func _ready():
    value = start_value
    ui_bar.update_value(value, max_value)

func add(amount: float):
    value = clampf(value + amount, 0.0, max_value)

func subtract(amount: float):
    value = clampf(value - amount, 0.0, max_value)

func update_ui_bar():
    if ui_bar:
        ui_bar.update_value(value, max_value)
