@tool
extends Button

@export var label_text: String = "Unit":
	set(new_value):
		label_text = new_value
		_update_view()
@export var button_icon: Texture2D:
	set(new_value):
		button_icon = new_value
		_update_view()
@export var gold_cost: int = 100:
	set(new_value):
		gold_cost = new_value
		_update_view()
@export var wood_cost: int = 100:
	set(new_value):
		wood_cost = new_value
		_update_view()

@onready var _entity_name_label = $VBoxContainer/EntityNameLabel
@onready var _entity_icon = $VBoxContainer/EntityIcon
@onready var _gold_label = $VBoxContainer/GoldCostLabel
@onready var _wood_label = $VBoxContainer/WoodCostLabel

func _ready() -> void:
	_update_view()

func _update_view() -> void:
	_entity_name_label.text = label_text
	_entity_icon.texture = button_icon
	_gold_label.text = str(gold_cost)
	_wood_label.text = str(wood_cost)
