extends CanvasLayer

signal start_game

@onready var _top_left_icons := $TopLeftIcons
@onready var _start_game_button := $VBoxContainer/StartGameButton
@onready var _quit_button := $VBoxContainer/QuitButton


func _ready() -> void:
	_top_left_icons.back_button.visible = false
	_top_left_icons.pause_button.visible = false
	_top_left_icons.play_button.visible = false

	_start_game_button.pressed.connect(_on_start_game_button_pressed)
	_quit_button.pressed.connect(_on_quit_button_pressed)


func _on_start_game_button_pressed() -> void:
	start_game.emit()
	queue_free()

func _on_quit_button_pressed() -> void:
	var confirm_quit_dialog = \
		load("res://scenes/ui/components/molecules/confirm_quit_dialogue.tscn").instantiate()
	add_child(confirm_quit_dialog)
