extends CharacterBody2D

# Unit stats
const unit_speed := 80.0
const attack_damage := 10.0

# Unit state
var current_target: CollisionObject2D = null

# Signals
signal target_attacked(target, damage)

@onready var nav_agent := $NavigationAgent2D

func _ready() -> void:
    _set_closest_building()

func _process(delta: float) -> void:
    # Actualiza el objetivo actual. Si no hay objetivo válido, se para.
    if current_target == null or not is_instance_valid(current_target):
        _set_closest_building()
    if current_target == null:
        velocity = Vector2.ZERO
        move_and_slide()
        return

    # Pasa la posición del objetivo a NavigationAgent2D.
    nav_agent.target_position = current_target.global_position

    # Si ya ha llegado al objetivo, para y ataca.
    if nav_agent.is_navigation_finished():
        velocity = Vector2.ZERO
        target_attacked.emit(current_target, attack_damage)
        move_and_slide()
        return

    # Calcula la siguiente posición.
    var next_position = nav_agent.get_next_path_position()
    var direction = (next_position - global_position).normalized()
    velocity = direction * unit_speed
    move_and_slide()

# Busca el edificio más cercano.
func _set_closest_building() -> void:
    # Recoge la lista de edificios activos en el mapa.
    var buildings := get_tree().get_nodes_in_group("buildings")

    # Itera sobre la lista calculando la distancia al edificio.
    var closest_building: StaticBody2D = null
    var shortest_distance = INF
    for building in buildings:
        var distance := global_position.distance_to(building.global_position)
        if distance < shortest_distance:
            closest_building = building
            shortest_distance = distance

    # Asigna el edificio más cercano como objetivo.
    current_target = closest_building
