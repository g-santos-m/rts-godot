@tool
extends PanelContainer

@export var count: String = "2000":
	set(new_value):
		count = new_value
		_update_view()
@export var icon: Texture2D:
	set(new_value):
		icon = new_value
		_update_view()

@onready var _icon_texture = $HBoxContainer/IconTexture
@onready var _count_label = $HBoxContainer/CountLabel

func _ready() -> void:
	_update_view()

func _update_view() -> void:
	_icon_texture.texture = icon
	_count_label.text = count
