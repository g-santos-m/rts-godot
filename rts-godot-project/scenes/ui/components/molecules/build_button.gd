@tool
class_name BuildButton
extends Button

@export var label_text: String = "Unit":
	set(new_value):
		label_text = new_value
		update_view()
@export var button_icon: Texture2D:
	set(new_value):
		button_icon = new_value
		update_view()
var gold_cost: int = 10
var wood_cost: int = 10

@onready var _entity_name_label: LabelSmall = $VBoxContainer/EntityNameLabel
@onready var _entity_icon: TextureRect = $VBoxContainer/EntityIcon
@onready var _gold_label: LabelIcon = $VBoxContainer/GoldCostLabel
@onready var _wood_label: LabelIcon = $VBoxContainer/WoodCostLabel

func _ready() -> void:
	update_view()

func update_view() -> void:
	if not is_node_ready():
		return

	_entity_name_label.text = label_text
	_entity_icon.texture = button_icon
	_gold_label.text = str(gold_cost)
	_wood_label.text = str(wood_cost)
