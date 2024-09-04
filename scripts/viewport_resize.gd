extends SubViewport

func _ready():
    get_tree().root.size_changed.connect(_on_size_changed) 

func _on_size_changed():
    var new_screen_size := DisplayServer.window_get_size()
    size = new_screen_size
