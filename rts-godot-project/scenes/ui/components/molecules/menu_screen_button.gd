@tool
class_name MenuScreenButton
extends Button

@export var label_text: String = "Start Game":
	set(new_value):
		label_text = new_value
		_update_view()

@onready var _label: LabelVeryBig = $LabelVeryBig

func _ready() -> void:
	_update_view()

func _update_view() -> void:
	if not is_node_ready():
		return

	_label.text = label_text
