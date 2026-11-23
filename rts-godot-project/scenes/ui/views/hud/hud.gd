extends CanvasLayer

signal spawn_entity(entity_name: String)
signal back_to_menu

@onready var _build_panel := $BuildPanel
@onready var _top_bar_icons := $TopBar/HBoxContainer/TopBarIcons

func _ready() -> void:
	_build_panel.spawn_entity.connect(_on_build_panel_spawn_entity)
	_top_bar_icons.back_button_pressed.connect(_on_back_button_pressed)
	_top_bar_icons.pause_button_pressed.connect(_on_pause_button_pressed)

func show_game_over() -> void:
	_top_bar_icons.set_pause_button_enabled(false)
	$BackgroundCover.visible = true
	var game_over_msg = load("res://scenes/ui/components/atoms/game_over.tscn").instantiate()
	add_child(game_over_msg)

func show_game_won() -> void:
	_top_bar_icons.set_pause_button_enabled(false)
	$BackgroundCover.visible = true
	var game_won_msg = load("res://scenes/ui/components/atoms/game_won.tscn").instantiate()
	add_child(game_won_msg)


func set_pause_button_enabled(is_enabled: bool) -> void:
	_top_bar_icons.set_pause_button_enabled(is_enabled)


func _on_build_panel_spawn_entity(entity_name: String) -> void:
	spawn_entity.emit(entity_name)


func _on_back_button_pressed() -> void:
	var confirm_back_dialog = \
		load("res://scenes/ui/components/molecules/confirm_back_dialogue.tscn").instantiate()
	confirm_back_dialog.back_to_menu.connect(_on_back_to_menu)
	add_child(confirm_back_dialog)


func _on_pause_button_pressed(is_paused: bool) -> void:
	$BackgroundCover.visible = is_paused
	$GamePaused.visible = is_paused


func _on_back_to_menu() -> void:
	back_to_menu.emit()
