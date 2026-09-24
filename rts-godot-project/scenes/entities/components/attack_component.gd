extends Node2D

# Estadísticas
var _entity_name: String
var _attack_damage: float
var _attack_rate: float     # Seguntos entre ataques

# Estado
var on_cooldown = false

@onready var timer = $Timer
@onready var printer: Printer

func setup(
    entity_name: String,
    attack_damage: float,
    attack_rate: float
) -> void:
    _entity_name = entity_name
    _attack_damage = attack_damage
    _attack_rate = attack_rate
    printer = Printer.new(entity_name)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    timer.one_shot = true
    timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout() -> void:
    on_cooldown = false

func attack_target(target: CollisionObject2D) -> void:
    if not on_cooldown:
        target.take_damage(_attack_damage)
        on_cooldown = true
        timer.start(_attack_rate)
        printer.cprint("deals ", _attack_damage, " damage to ", target.name)
