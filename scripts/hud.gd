extends Control

@onready var player = Global.player_instance
@onready var staminaBar: ProgressBar = $StaminaBar
@onready var staminaTimer: Timer = $StaminaBar/Timer

var hide_stamina: bool = false

func _ready() -> void:
    SignalBus.player_speed_updated.connect(_speed_updated)

func _process(delta: float) -> void:
    pass


func _speed_updated(_speed: float, stamina: float, max_value: float):
    staminaBar.value = stamina / max_value * 100.0
    
    if staminaBar.value == staminaBar.max_value and staminaTimer.time_left == 0:
        staminaTimer.start()
        print_debug("TIMER STARTED")
    elif staminaBar.value != staminaBar.max_value:
        hide_stamina = false
    
    staminaBar.visible = !hide_stamina


func _on_stamina_timer_timeout():
    if staminaBar.value == staminaBar.max_value:
        hide_stamina = true
