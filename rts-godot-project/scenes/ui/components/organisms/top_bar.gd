extends PanelContainer

signal mouse_hover(is_hovering: bool)


func _ready() -> void:
	mouse_entered.connect(func(): mouse_hover.emit(true))
	mouse_exited.connect(func(): mouse_hover.emit(false))
