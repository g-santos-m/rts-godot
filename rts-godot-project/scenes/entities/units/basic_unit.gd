extends CharacterBody2D


@export var speed: float = 300.0
var selected: bool = false
var destiny_position: Vector2

func _ready() -> void:
	destiny_position = global_position


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		selected = true
		modulate = Color(1.0, 0.5, 0.5)
		get_viewport().set_input_as_handled()
		
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton  and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if selected:
				selected = false
				modulate = Color(1.0, 1.0, 1.0)
				
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if selected:
				destiny_position = get_global_mouse_position()
			
func _physics_process(delta: float) -> void:
	if global_position.distance_to(destiny_position) > 5.0:
		var direction = global_position.direction_to(destiny_position)
		velocity = direction * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO
