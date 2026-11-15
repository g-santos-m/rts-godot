extends PanelContainer

signal spawn_entity(entity_name: String)
signal clear_enemies

@onready var castle_button := $GridContainer/CastleButton
@onready var zombie_button := $GridContainer/ZombieButton
@onready var fat_zombie_button := $GridContainer/FatZombieButton
@onready var clear_enemies_button := $GridContainer/ClearEnemiesButton


func _ready() -> void:
	castle_button.pressed.connect(_on_castle_button_pressed)
	zombie_button.pressed.connect(_on_zombie_button_pressed)
	fat_zombie_button.pressed.connect(_on_fat_zombie_button_pressed)
	clear_enemies_button.pressed.connect(_on_clear_enemies_pressed)

func _on_castle_button_pressed() -> void:
	spawn_entity.emit("castle")

func _on_zombie_button_pressed() -> void:
	spawn_entity.emit("zombie")

func _on_fat_zombie_button_pressed() -> void:
	spawn_entity.emit("fat_zombie")

func _on_clear_enemies_pressed() -> void:
	clear_enemies.emit()
