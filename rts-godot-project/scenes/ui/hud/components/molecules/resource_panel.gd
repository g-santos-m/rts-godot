extends MarginContainer

var _resource_manager: Node

@onready var _pop_indicator = $VBoxContainer/PopulationIndicator
@onready var _gold_indicator = $VBoxContainer/GoldIndicator
@onready var _wood_indicator = $VBoxContainer/WoodIndicator

func _ready() -> void:
	_resource_manager = get_tree().get_first_node_in_group("resource_manager")
	_resource_manager.resources_updated.connect(_on_resources_updated)

	_on_resources_updated(_resource_manager.get_resources_dict())

func _on_resources_updated(resources: Dictionary) -> void:
	_pop_indicator.count = "%d/%d" % [resources["population"], resources["max_population"]]
	_gold_indicator.count = str(resources["gold"])
	_wood_indicator.count = str(resources["wood"])
