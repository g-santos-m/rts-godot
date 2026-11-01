@tool
extends MarginContainer

@export var text: String = "Label":
	set(new_value):
		text = new_value
		_update_text()
@export var icon: Texture2D:
	set(new_value):
		icon = new_value
		_update_icon()

@onready var _rich_text_label = $HFlowContainer/RichTextLabel
@onready var _texture_rect = $HFlowContainer/TextureRect

func _ready() -> void:
	_update_text()
	_update_icon()

func _update_text() -> void:
	_rich_text_label.text = "[b][font_size=14][color=#eee]" + text

func _update_icon() -> void:
	_texture_rect.texture = icon
