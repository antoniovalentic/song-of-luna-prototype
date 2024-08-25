extends SubViewportContainer


func _ready() -> void:
    self.visible = false
    SignalBus.gui_hidden.connect(_on_gui_hidden)
    SignalBus.gui_shown.connect(_on_gui_shown)


func _on_gui_hidden():
    self.visible = false

func _on_gui_shown():
    self.visible = true