extends CharacterBody2D

# Estadísticas
const UNIT_SPEED = 200.0
const ATTACK_DAMAGE = 4.0
const ATTACK_RATE = 1.0      # Segundos entre ataques

static var id := 1

# Estado
var _current_target: CollisionObject2D

@onready var _nav_agent := $NavigationAgent2D
@onready var _attack_comp := $AttackComponent

@onready var _printer := Printer.new(name)

func _ready() -> void:
    id += 1
    _attack_comp.setup(name, ATTACK_DAMAGE, ATTACK_RATE)
    _printer.cprint("has spawned at ", global_position)
    _set_closest_building()

func _process(delta: float) -> void:
    # Actualiza el objetivo actual. Si no hay objetivo válido, se para.
    if _current_target == null or not is_instance_valid(_current_target):
        _set_closest_building()
    if _current_target == null:
        velocity = Vector2.ZERO
        move_and_slide()
        return

    # Pasa la posición del objetivo a NavigationAgent2D.
    _nav_agent.target_position = _current_target.global_position

    # Si ya ha llegado al objetivo, para y ataca.
    if _nav_agent.is_navigation_finished():
        velocity = Vector2.ZERO
        _attack_comp.attack_target(_current_target)
        move_and_slide()
        return

    # Calcula la siguiente posición.
    var next_position = _nav_agent.get_next_path_position()
    var direction: Vector2 = (next_position - global_position).normalized()
    $Sprite2D.flip_h = direction.x < 0
    velocity = direction * UNIT_SPEED
    move_and_slide()

# Busca el edificio más cercano.
func _set_closest_building() -> void:
    # Recoge la lista de edificios activos en el mapa.
    var buildings := get_tree().get_first_node_in_group("buildings").get_children()

    # Itera sobre la lista calculando la distancia al edificio.
    var closest_building: StaticBody2D = null
    var shortest_distance = INF
    for building in buildings:
        var distance := global_position.distance_to(building.global_position)
        if distance < shortest_distance:
            closest_building = building
            shortest_distance = distance

    # Asigna el edificio más cercano como objetivo.
    _current_target = closest_building
    if _current_target:
        _printer.cprint("is targeting ", _current_target.name, " at ", _current_target.global_position)
