extends Node

# Estadísticas
var _entity_name: String
var _attack_damage: float
var _attack_rate: float     # Seguntos entre ataques

# Estado
var _on_cooldown = false

@onready var _timer = $Timer
@onready var _printer: Printer

func setup(
    entity_name: String,
    attack_damage: float,
    attack_rate: float
) -> void:
    _entity_name = entity_name
    _attack_damage = attack_damage
    _attack_rate = attack_rate
    _printer = Printer.new(entity_name)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    _timer.one_shot = true
    _timer.timeout.connect(_on_timer_timeout)

func attack_target(target: CollisionObject2D) -> void:
    if not _on_cooldown:
        target.take_damage(_attack_damage)
        _on_cooldown = true
        _timer.start(_attack_rate)
        _printer.cprint("deals ", _attack_damage, " damage to ", target.name)

func _on_timer_timeout() -> void:
    _on_cooldown = false
