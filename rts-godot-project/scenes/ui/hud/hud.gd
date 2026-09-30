extends CanvasLayer

signal spawn_unit(unit_name: String)

@onready var castle_button := $MarginContainer/PanelContainer/VBoxContainer/CastleButton
@onready var zombie_button := $MarginContainer/PanelContainer/VBoxContainer/ZombieButton

func _ready() -> void:
    castle_button.pressed.connect(_on_castle_button_pressed)
    zombie_button.pressed.connect(_on_zombie_button_pressed)

func _on_castle_button_pressed() -> void:
    spawn_unit.emit("castle")

func _on_zombie_button_pressed() -> void:
    spawn_unit.emit("zombie")
