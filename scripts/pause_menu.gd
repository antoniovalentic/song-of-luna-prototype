extends CanvasLayer
class_name PauseMenu

signal resume_pressed()
signal quit_pressed()

@onready var resume_btn: Button = %ResumeButton
@onready var quit_btn: Button = %QuitButton

func _ready():
    pass


func _on_quit_button_pressed():
    quit_pressed.emit()

func _on_resume_button_pressed():
    resume_pressed.emit()
