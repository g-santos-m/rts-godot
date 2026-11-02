@tool
class_name LabelIcon
extends MarginContainer

@export var text: String = "Label":
	set(new_value):
		text = new_value
		_update_view()
@export var icon: Texture2D:
	set(new_value):
		icon = new_value
		_update_view()

@onready var _rich_text_label = $HBoxContainer/RichTextLabel
@onready var _texture_rect = $HBoxContainer/TextureRect

func _ready() -> void:
	_update_view()

func _update_view() -> void:
	if not is_node_ready():
		return

	_rich_text_label.text = "[b][font_size=14][color=#eee]" + text
	_texture_rect.texture = icon
