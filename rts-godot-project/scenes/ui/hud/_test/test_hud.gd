extends CanvasLayer

signal spawn_unit(unit_name: String)

@onready var castle_button := $MarginContainer/PanelContainer/HBoxContainer/VBoxContainer/CastleButton
@onready var house_button := $MarginContainer/PanelContainer/HBoxContainer/VBoxContainer/HouseButton
@onready var zombie_button := $MarginContainer/PanelContainer/HBoxContainer/VBoxContainer2/ZombieButton

func _ready() -> void:
    castle_button.pressed.connect(_on_castle_button_pressed)
    house_button.pressed.connect(_on_house_button_pressed)
    zombie_button.pressed.connect(_on_zombie_button_pressed)

func _on_castle_button_pressed() -> void:
    spawn_unit.emit("castle")

func _on_house_button_pressed() -> void:
    spawn_unit.emit("house")

func _on_zombie_button_pressed() -> void:
    spawn_unit.emit("zombie")
