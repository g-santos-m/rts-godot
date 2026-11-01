extends MarginContainer

signal go_back
signal is_paused(is_paused: bool)
signal is_muted(is_muted: bool)

var _is_paused := false
var _is_muted := false

@onready var _back_button = $HBoxContainer/BackButton
@onready var _pause_button = $HBoxContainer/PauseButton
@onready var _mute_button = $HBoxContainer/MuteButton

func _ready() -> void:
	_back_button.pressed.connect(_on_back_button_pressed)
	_pause_button.pressed.connect(_on_pause_button_pressed)
	_mute_button.pressed.connect(_on_mute_button_pressed)

func _on_back_button_pressed() -> void:
	go_back.emit()

func _on_pause_button_pressed() -> void:
	_is_paused = !is_paused
	is_paused.emit(_is_paused)

	if _is_paused == false:
		_pause_button.icon = load("res://assets/textures/ui/hud/pause_96dp_DBAC46_FILL1_wght400_GRAD0_opsz48.png")
	else:
		_pause_button.icon = load("res://assets/textures/ui/hud/play_arrow_96dp_DBAC46_FILL1_wght400_GRAD0_opsz48.png")

func _on_mute_button_pressed() -> void:
	_is_muted = !is_muted
	is_muted.emit(_is_muted)

	if _is_muted == false:
		_mute_button.icon = load("res://assets/textures/ui/hud/volume_mute_96dp_DBAC46_FILL1_wght400_GRAD0_opsz48.png")
	else:
		_mute_button.icon = load("res://assets/textures/ui/hud/volume_off_96dp_DBAC46_FILL1_wght400_GRAD0_opsz48.png")
