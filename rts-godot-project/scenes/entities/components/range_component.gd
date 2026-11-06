extends Area2D

signal body_in_range(body: Node2D, is_in_range: bool)

@onready var _printer: Printer

func setup(printer: Printer) -> void:
	_printer = printer

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	body_in_range.emit(body, true)
	_printer.cprint("has detected ", body.name, " in range")

func _on_body_exited(body: Node2D) -> void:
	body_in_range.emit(body, false)
