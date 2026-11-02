extends PanelContainer

@onready var _confirm_button = $VBoxContainer/HBoxContainer/ConfirmQuitButton
@onready var _cancel_button = $VBoxContainer/HBoxContainer/CancelButton
@onready var _printer = Printer.new(name)

func _ready() -> void:
	get_tree().paused = true

	_confirm_button.pressed.connect(_on_confirm)
	_cancel_button.pressed.connect(_on_cancel)

func _on_confirm() -> void:
	_printer.cprint("confirm button pressed")
	get_tree().quit()

func _on_cancel() -> void:
	get_tree().paused = false
	_printer.cprint("cancel button pressed")
	queue_free()
