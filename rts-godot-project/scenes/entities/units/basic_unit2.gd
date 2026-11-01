extends CharacterBody2D

static var id := 1

@onready var _resource_timer = $ResourceTimer
var _current_resource: PhysicsBody2D = null
@onready var _nav_agent = $NavigationAgent2D
var _resource_manager : Node
@onready var _range_comp := $RangeComponent
@onready var _printer := Printer.new(name)
@export var speed = 300
var av = Vector2.ZERO
var avoid_weight = 0.1
var selected = false:
	set = set_selected
var target = null

func _ready() -> void:
	id += 1
	_printer.cprint("has spawned at ", global_position)
	_range_comp.setup(_printer)
	_range_comp.body_in_range.connect(_on_body_in_range)
	_resource_manager = get_tree().get_first_node_in_group("resource_manager")
	#Conectar señales
	_resource_timer.timeout.connect(_on_resource_timer_timeout)
	_range_comp.body_exited.connect(_on_body_exited)

#Cuando el recurso entra en rango, se guarda,se comienza a recolectar y se inicia el ResourceTimer
func _on_body_in_range(body: PhysicsBody2D) -> void:
	if body.is_in_group("gold_resource") or body.is_in_group("wood_resource"):
		_current_resource = body
		_farm_resource()
		_resource_timer.start()
		
#Cuando el recurso sale de rango se deja de recolectar
func _on_body_exited(body: PhysicsBody2D) -> void:
	if body == _current_resource:
		_current_resource = null
		_resource_timer.stop()
	
#Lógica de recolectar
func _farm_resource() -> void:
	if _current_resource.is_in_group("gold_resource"):
		_resource_manager._increment_gold()
	elif _current_resource.is_in_group("wood_resource"):
		_resource_manager._increment_wood()
		
#Recolectar cada vez que el ResourceTimer llega a 0
func _on_resource_timer_timeout() -> void:
	if _current_resource != null:
		_farm_resource()

#func _on_body_in_range(body: PhysicsBody2D) -> void:
#	#Hacer animacion
#	#incrementar recursos
#	if body.is_in_group("gold_resource"):
#		_resource_manager._increment_gold()
#	elif body.is_in_group("wood_resource"):
#		_resource_manager._increment_wood()
#

func set_selected(value):
	selected = value
	if selected:
		$Sprite2D.self_modulate = Color.AQUA;
	else:
		$Sprite2D.self_modulate = Color.WHITE;

func set_target():
	if selected:
		_nav_agent.target_position = get_global_mouse_position()
		target = get_global_mouse_position()

#func avoid():
#	var result = Vector2.ZERO
#	var neighbours = $Detect.get_overlapping_bodies()
#	if neighbours:
#		for n in neighbours:
#			result += n.position.direction_to(position)
#		result /= neighbours.size()
#	return result.normalized()

#func _input(event):
#	if selected:
#		if event.is_action_pressed("set_target"):
#			target = get_global_mouse_position()
#		nav_agent.target_position = target

#####func _physics_process(delta) -> void:
#####	if _nav_agent.is_navigation_finished():
#####		return
#####	velocity = Vector2.ZERO
#####	if target != null:
#####		var next_position = _nav_agent.get_next_path_position()
#####		var direction: Vector2 = (next_position - global_position).normalized()
######		velocity = position.direction_to(target)
#####		velocity = direction * speed
#####		move_and_slide()
#####		
func _input(event: InputEvent) -> void:
	if selected and event.is_action_pressed("set_target"):
		_nav_agent.target_position = get_global_mouse_position()
		
func _physics_process(_delta) -> void:
	# Si ya llegó al final de la ruta (o no tiene una), se detiene y no hace nada más
	if _nav_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		return
		
	# Calcula el siguiente punto en el mapa de navegación
	var next_position = _nav_agent.get_next_path_position()
	
	# Obtiene la dirección hacia ese punto
	var direction = global_position.direction_to(next_position)
	
	# Aplica la velocidad y mueve al personaje
	velocity = direction * speed
	move_and_slide()
	

#	velocity = Vector2.ZERO
#	if target != null:
#		velocity = position.direction_to(target)
#		if position.distance_to(target) < target_radius:
#			target = null
#	#av = avoid()
#	velocity = (velocity + av * avoid_weight).normalized() * speed
#	move_and_collide(velocity * delta)
#	#if velocity != Vector2.ZERO:
#	#	$AnimationPlayer.play("running")
#	#else:
#	#	$AnimationPlater.play("idle")



###extends CharacterBody2D
###
###@export var speed = 300
###var target = null
###
###func _input(event):
###	if event.is_action_pressed("set_target"):
###		target = get_global_mouse_position()
###
###func _physics_process(delta):
###	if target != null:
###		velocity = position.direction_to(target)
###	velocity = velocity.normalized() * speed
###	move_and_collide(velocity * delta)
