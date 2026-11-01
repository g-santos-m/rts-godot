@tool
class_name LabelBig
extends MarginContainer

@export var text: String = "Label":
	set(new_value):
		text = new_value
		_update_text()

@onready var _rich_text_label = $RichTextLabel

func _ready() -> void:
	_update_text()

func _update_text() -> void:
	if not is_node_ready():
		return

	_rich_text_label.text = "[b][font_size=20][color=#eee]" + text
