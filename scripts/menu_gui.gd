extends Control
class_name MenuGUI

var is_open = false

func _ready():
	close()

func _input(event: InputEvent):
	if event.is_action_pressed("ui_inventory"):
		if is_open:
			close()
		else:
			open()
	elif event.is_action_pressed("ui_cancel"):
		if is_open:
			close()

func close():
	visible = false
	is_open = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func open():
	visible = true
	is_open = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
