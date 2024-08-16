extends ProgressBar
class_name  HealthUiBar

@onready var text: Label = $Text

var format_need_text: String = "%s/%s"

func _ready():
	pass

func update_value(new_value: float, new_max: float):
	max_value = new_max
	value = new_value
	text.text = format_need_text % [int(value), int(max_value)]
