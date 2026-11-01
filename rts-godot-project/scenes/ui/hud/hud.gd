extends CanvasLayer

signal spawn_entity(entity_name: String)

@onready var _build_panel := $BuildPanel

func _ready() -> void:
	_build_panel.spawn_entity.connect(_on_build_panel_spawn_entity)

func show_game_over() -> void:
	var game_over_msg = preload("res://scenes/ui/hud/components/atoms/game_over.tscn").instantiate()
	add_child(game_over_msg)

func _on_build_panel_spawn_entity(entity_name: String) -> void:
	spawn_entity.emit(entity_name)
