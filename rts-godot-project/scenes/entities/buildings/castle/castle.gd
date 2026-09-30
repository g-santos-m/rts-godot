extends StaticBody2D

# Estadísticas
const MAX_HEALTH := 10.0

static var id := 1

@onready var _health_comp := $HealthComponent
@onready var _printer := Printer.new(name)

func _ready() -> void:
    id += 1
    _health_comp.setup(MAX_HEALTH, _printer)
    # Hay que llamar a paint_bar() al principio para que la barra de vida tome
    # tamaño correcto y poder posicionarla adecuadamente después.
    _health_comp.paint_bar()
    # Posiciona la barra centrada horizontalmente y 10 píxeles sobre la hitbox
    # de la entidad.
    _health_comp.position = Vector2(
        -(_health_comp.get_child(0).polygon[1].x / 2),
        -($CollisionShape2D.shape.size.y / 2 + 10)
    )
    _health_comp.destroyed.connect(_on_destroyed)
    _printer.cprint("has spawned at ", global_position)

func take_damage(damage: float) -> void:
    _health_comp.take_damage(damage)

func _on_destroyed() -> void:
    _printer.cprint("has been destroyed")
    queue_free()
