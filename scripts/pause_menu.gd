extends CanvasLayer
class_name PauseMenu

signal resume_pressed()
signal quit_pressed()

@onready var resume_btn: Button = %ResumeButton
@onready var quit_btn: Button = %QuitButton

func _ready():
    SignalBus.game_paused.connect(_on_game_paused)
    SignalBus.game_unpaused.connect(_on_game_unpaused)

    if Global.get_pause_game():
        visible = true
    else:
        visible = false

func _unhandled_key_input(event: InputEvent):
    # Show main menu on Esc press
    if event.is_action_pressed("ui_cancel"):
        Global.set_pause_game(!Global.get_pause_game())


func _on_quit_button_pressed():
    quit_pressed.emit()

func _on_resume_button_pressed():
    resume_pressed.emit()

func _on_game_paused():
    visible = true

func _on_game_unpaused():
    visible = false
