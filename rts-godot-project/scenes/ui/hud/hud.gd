extends CanvasLayer

signal spawn_unit(unit_name: String)

@onready var house_button := $MarginContainer/PanelContainer/HBoxContainer/VBoxContainer/HouseButton

func _ready() -> void:
    house_button.pressed.connect(_on_house_button_pressed)

func show_game_over() -> void:
    var game_over_msg = preload("res://scenes/ui/hud/game_over.tscn").instantiate()
    add_child(game_over_msg)

func _on_house_button_pressed() -> void:
    spawn_unit.emit("house")
