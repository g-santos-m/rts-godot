class_name House
extends BaseBuilding

var _resource_manager: ResourceManager

func _ready() -> void:
	super._ready()
	_resource_manager = get_tree().get_first_node_in_group("resource_manager")
	_resource_manager.increment_max_population()

func _on_destroyed() -> void:
	_resource_manager.decrement_max_population()
	super._on_destroyed()
