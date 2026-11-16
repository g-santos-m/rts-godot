@tool
extends TextureButton

@export var icon: Texture2D:
	set(new_value):
		icon = new_value
		_update_icon()

func _ready() -> void:
	_update_icon()

func _update_icon() -> void:
	texture_normal = icon
