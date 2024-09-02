extends Control

@onready var player = Global.player_instance
@onready var staminaBar: ProgressBar = $StaminaBar
@onready var staminaTimer: Timer = $StaminaBar/Timer
@onready var reloadBar: ProgressBar = $ReloadBar
@onready var reloadTimer: Timer = $ReloadBar/Timer
@onready var hurt_texture: TextureRect = $HurtTexture

var hide_stamina: bool = false

func _ready():
    reloadBar.visible = false
    SignalBus.player_speed_updated.connect(_speed_updated)
    SignalBus.reload_started.connect(_on_reload_started)
    SignalBus.game_paused.connect(_on_game_paused)
    SignalBus.game_unpaused.connect(_on_game_unpaused)
    SignalBus.player_health_updated.connect(_on_player_health_updated)

func _process(_delta: float):  
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
    if reloadTimer.time_left == 0:
        reloadBar.visible = true
        reloadTimer.start()


func _on_stamina_timer_timeout():
    if staminaBar.value == staminaBar.max_value:
        hide_stamina = true

func _on_reload_timer_timeout():
    reloadBar.visible = false
    SignalBus.reload_done.emit()

func _on_game_paused():
    visible = false

func _on_game_unpaused():
    visible = true

func _on_player_health_updated(value: float, max_value: float):
    var percentage: float = abs(value/max_value - 1)
    hurt_texture.modulate = Color8(172, 50, 50, int(percentage * 255))