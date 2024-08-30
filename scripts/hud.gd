extends Control

@onready var player = Global.player_instance
@onready var staminaBar: ProgressBar = $StaminaBar
@onready var staminaTimer: Timer = $StaminaBar/Timer
@onready var reloadBar: ProgressBar = $ReloadBar
@onready var reloadTimer: Timer = $ReloadBar/Timer

var hide_stamina: bool = false

func _ready() -> void:
    reloadBar.visible = false
    SignalBus.player_speed_updated.connect(_speed_updated)
    SignalBus.reload_started.connect(_on_reload_started)

func _process(_delta: float) -> void:
    if reloadBar.visible == true:
        reloadBar.value = (reloadTimer.wait_time - reloadTimer.time_left) / reloadTimer.wait_time * 100.0


func _speed_updated(_speed: float, stamina: float, max_value: float):
    staminaBar.value = stamina / max_value * 100.0
    
    # Hide bar after 1 sec if full and not sprinting
    if staminaBar.value == staminaBar.max_value and staminaTimer.time_left == 0:
        staminaTimer.start()
    elif staminaBar.value != staminaBar.max_value:
        hide_stamina = false
    
    staminaBar.visible = !hide_stamina

func _on_reload_started():
    reloadBar.visible = true
    reloadTimer.start()


func _on_stamina_timer_timeout():
    if staminaBar.value == staminaBar.max_value:
        hide_stamina = true

func _on_reload_timer_timeout():
    reloadBar.visible = false
    SignalBus.reload_done.emit()
