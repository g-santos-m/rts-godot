extends CanvasLayer

signal spawn_entity(entity_name: String)
#region TESTS
signal clear_enemies
#endregion

@onready var _build_panel := $BuildPanel
@onready var _top_bar_icons := $TopBar/HBoxContainer/TopBarIcons
#region TESTS
@onready var _testing_panel := $TestingPanel
#endregion

func _ready() -> void:
	_build_panel.spawn_entity.connect(_on_build_panel_spawn_entity)
	_top_bar_icons.back_button_pressed.connect(_on_back_button_pressed)
	_top_bar_icons.pause_button_pressed.connect(_on_pause_button_pressed)
	#region TESTS
	# Para spawnear entidades, conecta con la misma función que el BuildPanel.
	_testing_panel.spawn_entity.connect(_on_build_panel_spawn_entity)
	_testing_panel.clear_enemies.connect(_on_testing_panel_clear_enemies)
	#endregion

func show_game_over() -> void:
	_top_bar_icons.disable_pause_button()
	var game_over_msg = load("res://scenes/ui/hud/components/atoms/game_over.tscn").instantiate()
	add_child(game_over_msg)

func _on_build_panel_spawn_entity(entity_name: String) -> void:
	spawn_entity.emit(entity_name)

func _on_back_button_pressed() -> void:
	var confirm_quit_dialog = \
		load("res://scenes/ui/hud/components/molecules/confirm_quit_dialoge.tscn").instantiate()
	add_child(confirm_quit_dialog)

func _on_pause_button_pressed(is_paused: bool) -> void:
	$GamePaused.visible = is_paused

#region TESTS
func _on_testing_panel_clear_enemies() -> void:
	clear_enemies.emit()
#endregion
