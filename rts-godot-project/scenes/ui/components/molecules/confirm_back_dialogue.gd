extends PanelContainer

signal back_to_menu

@onready var _confirm_back_button = $VBoxContainer/HBoxContainer/ConfirmBackButton
@onready var _cancel_button = $VBoxContainer/HBoxContainer/CancelButton
@onready var _printer = Printer.new(name)

func _ready() -> void:
	get_tree().paused = true

	_confirm_back_button.pressed.connect(_on_confirm_back)
	_cancel_button.pressed.connect(_on_cancel)

func _on_confirm_back() -> void:
	_printer.cprint("confirm back button pressed")
	get_tree().paused = false
	back_to_menu.emit()
	queue_free()

func _on_cancel() -> void:
	get_tree().paused = false
	_printer.cprint("cancel button pressed")
	queue_free()
