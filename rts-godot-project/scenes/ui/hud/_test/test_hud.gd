extends CanvasLayer

signal spawn_unit(unit_name: String)
signal clear_enemies

@onready var castle_button := $MarginContainer/PanelContainer/HBoxContainer/VBoxContainer/CastleButton
@onready var house_button := $MarginContainer/PanelContainer/HBoxContainer/VBoxContainer/HouseButton
@onready var zombie_button := $MarginContainer/PanelContainer/HBoxContainer/VBoxContainer2/ZombieButton
@onready var clear_enemies_button := $MarginContainer/PanelContainer/HBoxContainer/VBoxContainer3/ClearEnemiesButton
@onready var basic_unit_button := $MarginContainer/PanelContainer/HBoxContainer/VBoxContainer2/BasicUnitButton

func _ready() -> void:
	castle_button.pressed.connect(_on_castle_button_pressed)
	house_button.pressed.connect(_on_house_button_pressed)
	zombie_button.pressed.connect(_on_zombie_button_pressed)
	clear_enemies_button.pressed.connect(_on_clear_enemies_pressed)
	basic_unit_button.pressed.connect(_on_basic_unit_button_pressed)

func _on_castle_button_pressed() -> void:
	spawn_unit.emit("castle")

func _on_house_button_pressed() -> void:
	spawn_unit.emit("house")

func _on_zombie_button_pressed() -> void:
	spawn_unit.emit("zombie")

func _on_clear_enemies_pressed() -> void:
	clear_enemies.emit()

func _on_basic_unit_button_pressed() -> void:
	spawn_unit.emit("basic_unit")
