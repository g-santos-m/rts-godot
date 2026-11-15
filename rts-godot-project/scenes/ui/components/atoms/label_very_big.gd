@tool
class_name LabelVeryBig
extends MarginContainer

@export var text: String = "Label":
	set(new_value):
		text = new_value
		_update_text()

@export var shadowed: bool = false:
	set(new_value):
		shadowed = new_value
		_update_text()
@export var font_size: int = 48:
	set(new_value):
		font_size = new_value
		_update_text()

@onready var _rich_text_label = $RichTextLabel


func _ready() -> void:
	_update_text()


func _update_text() -> void:
	if not is_node_ready():
		return

	_rich_text_label.text = "[b][font_size=%d][color=#eee]%s" % [font_size, text]
	if shadowed:
		_rich_text_label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.6))
		_rich_text_label.add_theme_constant_override("outline_size", 12)
		_rich_text_label.add_theme_color_override("font_outline_color", Color(0.514, 0.4, 0.184, 1.0))
	else:
		_rich_text_label.remove_theme_color_override("font_shadow_color")
		_rich_text_label.remove_theme_constant_override("outline_size")
