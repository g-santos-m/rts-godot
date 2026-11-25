extends PanelContainer

signal spawn_entity(entity_name: String)
signal mouse_hover(is_hovering: bool)

@export var _build_costs: BuildCosts

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

	_worker_button.gold_cost = _build_costs.worker_gold
	_worker_button.wood_cost = _build_costs.worker_wood
	_knight_button.gold_cost = _build_costs.knight_gold
	_knight_button.wood_cost = _build_costs.knight_wood
	_archer_button.gold_cost = _build_costs.archer_gold
	_archer_button.wood_cost = _build_costs.archer_wood
	_house_button.gold_cost = _build_costs.house_gold
	_house_button.wood_cost = _build_costs.house_wood
	_wall_button.gold_cost = _build_costs.wall_gold
	_wall_button.wood_cost = _build_costs.wall_wood
	_tower_button.gold_cost = _build_costs.tower_gold
	_tower_button.wood_cost = _build_costs.tower_wood

	var buttons: Array = $GridContainer.get_children()
	for button in buttons:
		button.update_view()

	mouse_entered.connect(func(): mouse_hover.emit(true))
	mouse_exited.connect(func(): mouse_hover.emit(false))


func _on_button_pressed(entity_name: String) -> void:
	spawn_entity.emit(entity_name)
