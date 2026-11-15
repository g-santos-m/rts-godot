extends PanelContainer

signal spawn_entity(entity_name: String)

@onready var _worker_button: BuildButton = $GridContainer/WorkerButton
@onready var _knight_button: BuildButton = $GridContainer/KnightButton
@onready var _archer_button: BuildButton = $GridContainer/ArcherButton
@onready var _house_button: BuildButton = $GridContainer/HouseButton
@onready var _wall_button: BuildButton = $GridContainer/WallButton
@onready var _tower_button: BuildButton = $GridContainer/TowerButton

func _ready() -> void:
	_worker_button.pressed.connect(_on_button_pressed.bind("worker"))
	_knight_button.pressed.connect(_on_button_pressed.bind("knight"))
	_archer_button.pressed.connect(_on_button_pressed.bind("archer"))
	_house_button.pressed.connect(_on_button_pressed.bind("house"))
	_wall_button.pressed.connect(_on_button_pressed.bind("wall"))
	_tower_button.pressed.connect(_on_button_pressed.bind("tower"))

func _on_button_pressed(entity_name: String) -> void:
	spawn_entity.emit(entity_name)
