extends Control
class_name MenuGUI

var is_open = false

func _ready():
	close()

func _process(_delta: float):
	if Input.is_action_just_pressed("ui_inventory"):
		print_debug(is_open)
		if is_open:
			close()
		else:
			open()
	elif Input.is_action_just_pressed("ui_cancel"):
		if is_open:
			close()


func close():
	visible = false
	is_open = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	SignalBus.gui_hidden.emit()

func open():
	visible = true
	is_open = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	SignalBus.gui_shown.emit()
