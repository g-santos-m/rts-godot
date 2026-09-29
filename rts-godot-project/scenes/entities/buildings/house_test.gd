extends Sprite2D

var is_building = true
@onready var building_mode := $BuildingTest

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	building_mode.build_building.connect(_set_building_mode)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _set_building_mode ():
	is_building = false
	$StaticBody2D/CollisionShape2D.disabled = false
