extends MarginContainer

signal back_button_pressed
signal pause_button_pressed(is_paused: bool)

var _is_paused := false
var _is_muted := false

@onready var back_button = $HBoxContainer/BackButton
@onready var play_button = $HBoxContainer/PlayButton
@onready var pause_button = $HBoxContainer/PauseButton
@onready var unmute_button = $HBoxContainer/UnmuteButton
@onready var mute_button = $HBoxContainer/MuteButton
@onready var _printer := Printer.new(name)

func _ready() -> void:
	back_button.pressed.connect(_on_back_button_pressed)
	pause_button.pressed.connect(_on_pause_play_button_pressed)
	play_button.pressed.connect(_on_pause_play_button_pressed)
	mute_button.pressed.connect(_on_mute_unmute_button_pressed)
	unmute_button.pressed.connect(_on_mute_unmute_button_pressed)


# Para desabilitar la pausa desde el hud cuando el juego finaliza por Game Over o esta activo el
# diálogo de volver al menú.
func set_pause_button_enabled(is_enabled: bool) -> void:
	pause_button.disabled = not is_enabled

func _on_back_button_pressed() -> void:
	_printer.cprint("back button pressed")
	set_pause_button_enabled(false)
	back_button_pressed.emit()

func _on_pause_play_button_pressed() -> void:
	_printer.cprint("pause/play button pressed - _is_paused = ", _is_paused)
	_is_paused = !_is_paused
	pause_button_pressed.emit(_is_paused)
	get_tree().paused = _is_paused

	pause_button.visible = !_is_paused
	play_button.visible = _is_paused

func _on_mute_unmute_button_pressed() -> void:
	_printer.cprint("mute/unmute button pressed - _is_muted = ", _is_muted)
	_is_muted = !_is_muted
	$"/root/Soundtrack".playing = !_is_muted

	mute_button.visible = !_is_muted
	unmute_button.visible = _is_muted
