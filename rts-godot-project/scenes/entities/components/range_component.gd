extends Area2D

signal body_in_range(target: PhysicsBody2D)

@onready var _printer: Printer

func setup(printer: Printer) -> void:
    _printer = printer

func _ready() -> void:
    body_entered.connect(_on_body_entered)

func _on_body_entered(body: PhysicsBody2D) -> void:
    body_in_range.emit(body)
    _printer.cprint("has detected ", body.name, " in range")
