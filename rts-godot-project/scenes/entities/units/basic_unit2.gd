extends CharacterBody2D

static var id := 1

@onready var nav_agent = $NavigationAgent2D
var _resource_manager : Node
@onready var _range_comp := $RangeComponent
@onready var _printer := Printer.new(name)
@export var speed = 300
var av = Vector2.ZERO
var avoid_weight = 0.1
var target_radius = 50
var selected = false:
	set = set_selected
var target = null:
	set = set_target

func _ready() -> void:
	id += 1
	_printer.cprint("has spawned at ", global_position)
	_range_comp.setup(_printer)
	_range_comp.body_in_range.connect(_on_body_in_range)
	_resource_manager = get_tree().get_first_node_in_group("resource_manager")

func _on_body_in_range(body: PhysicsBody2D) -> void:
	#Hacer animacion
	#incrementar recursos
	if body.is_in_group("gold_resource"):
		_resource_manager._increment_gold()
	elif body.is_in_group("wood_resource"):
		_resource_manager._increment_wood()
		

func set_selected(value):
	selected = value
	if selected:
		$Sprite2D.self_modulate = Color.AQUA;
	else:
		$Sprite2D.self_modulate = Color.WHITE;

func set_target(value):
	target = value


#func avoid():
#	var result = Vector2.ZERO
#	var neighbours = $Detect.get_overlapping_bodies()
#	if neighbours:
#		for n in neighbours:
#			result += n.position.direction_to(position)
#		result /= neighbours.size()
#	return result.normalized()

#func _input(event):
#	if event.is_action_pressed("set_target"):
#		target = get_global_mouse_position()

func _physics_process(delta) -> void:
	if nav_agent.is_navigation_finished():
		return
	velocity = Vector2.ZERO
	if target != null:
		velocity = position.direction_to(target)
		if position.distance_to(target) < target_radius:
			target = null
	#av = avoid()
	velocity = (velocity + av * avoid_weight).normalized() * speed
	move_and_collide(velocity * delta)
	#if velocity != Vector2.ZERO:
	#	$AnimationPlayer.play("running")
	#else:
	#	$AnimationPlater.play("idle")


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
