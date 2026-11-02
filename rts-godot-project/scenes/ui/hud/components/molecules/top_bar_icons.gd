extends MarginContainer

signal back_button_pressed
signal pause_button_pressed(is_paused: bool)

var _is_paused := false
var _is_muted := false

@onready var _back_button = $HBoxContainer/BackButton
@onready var _play_button = $HBoxContainer/PlayButton
@onready var _pause_button = $HBoxContainer/PauseButton
@onready var _unmute_button = $HBoxContainer/UnmuteButton
@onready var _mute_button = $HBoxContainer/MuteButton
@onready var _printer := Printer.new(name)

func _ready() -> void:
	_back_button.pressed.connect(_on_back_button_pressed)
	_pause_button.pressed.connect(_on_pause_play_button_pressed)
	_play_button.pressed.connect(_on_pause_play_button_pressed)
	_mute_button.pressed.connect(_on_mute_unmute_button_pressed)
	_unmute_button.pressed.connect(_on_mute_unmute_button_pressed)

# Para desabilitar la pausa desde el hud cuando el juego finaliza por Game Over.
func disable_pause_button() -> void:
	_pause_button.disabled = true

func _on_back_button_pressed() -> void:
	_printer.cprint("back button pressed")
	back_button_pressed.emit()

func _on_pause_play_button_pressed() -> void:
	_printer.cprint("pause/play button pressed - _is_paused = ", _is_paused)
	_is_paused = !_is_paused
	pause_button_pressed.emit(_is_paused)
	get_tree().paused = _is_paused

	_pause_button.visible = !_is_paused
	_play_button.visible = _is_paused

func _on_mute_unmute_button_pressed() -> void:
	_printer.cprint("mute/unmute button pressed - _is_muted = ", _is_muted)
	_is_muted = !_is_muted
	$"/root/Soundtrack".playing = !_is_muted

	_mute_button.visible = !_is_muted
	_unmute_button.visible = _is_muted
