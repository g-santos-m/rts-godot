extends Camera2D

const HUD_TOP_BAR_HEIGHT = 180
const TILE_SIZE = 64
const MAX_ZOOM = 1
const MIN_ZOOM = 0.5
const ZOOM_STEP = 0.1

@export var camera_speed: float = 500.0		# Píxeles/segundo

var map_size: Vector2i

func _ready() -> void:
	var base_layer: TileMapLayer = get_tree().get_first_node_in_group("base_layer")
	map_size = base_layer.get_used_rect().size * TILE_SIZE

	limit_top = -HUD_TOP_BAR_HEIGHT
	limit_bottom = map_size.y
	limit_left = 0
	limit_right = map_size.x

	#force_update_scroll()
	#global_position = get_screen_center_position()

func _process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")
	global_position += direction * camera_speed * delta

	force_update_scroll()
	global_position = get_screen_center_position()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom_in"):
		_zoom_in()
	elif event.is_action_pressed("zoom_out"):
		_zoom_out()

func _zoom_in() -> void:
	var next_zoom_value: float = snappedf(zoom.x + ZOOM_STEP, ZOOM_STEP)
	if next_zoom_value <= MAX_ZOOM:
		_apply_zoom_at_mouse(next_zoom_value)

func _zoom_out() -> void:
# Cálculos extra para que el zoom no exceda el tamaño del mapa ni el mínimo permitido
	var next_zoom_value: float = snappedf(zoom.x - ZOOM_STEP, ZOOM_STEP)
	var next_viewport_size: Vector2 = get_viewport_rect().size / next_zoom_value
	if next_zoom_value >= MIN_ZOOM and \
		next_viewport_size.x <= map_size.x and \
		next_viewport_size.y <= map_size.y:
		_apply_zoom_at_mouse(next_zoom_value)

func _apply_zoom_at_mouse(target_zoom: float) -> void:
	global_position = get_screen_center_position()
	var old_mouse_position: Vector2 = get_global_mouse_position()
	zoom = Vector2(target_zoom, target_zoom)
	force_update_scroll()

	global_position += old_mouse_position - get_global_mouse_position()
	force_update_scroll()
	global_position = get_screen_center_position()
