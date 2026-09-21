extends CharacterBody2D
 
@onready var nav_agent = $NavigationAgent2D
#@onready var animation_player = $AnimationPlayer
 
var speed = 300
 
var selection_rect : Rect2
var selection_width : int
 
var select_mode : bool = false:
	set(value):
		select_mode = value
		if value:
			selection_rect = Rect2(Vector2(-8,-8), Vector2(16,16))
			selection_width = 1
		else:
			selection_rect = Rect2(0,0,0,0)
			selection_width = 0
		queue_redraw()
 
func _ready():
	name = "Unit"
 
func _draw():
	draw_rect(selection_rect,Color.GREEN, false, selection_width)
 
func _physics_process(delta):
	if nav_agent.is_navigation_finished():
		#if animation_player.current_animation != "idle":
			#animation_player.play("idle")
		return
 
	#animation(delta)
	var next_position = nav_agent.get_next_path_position()
	var direction = (next_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
 
func select():
	select_mode = true
 
func deselect():
	select_mode = false
 
 
func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			select_mode = true
			for unit in UnitManager.unit_selected:
				if unit != self:
					unit.deselect()
			UnitManager.unit_selected = [self]
 
func move_to(target_position):
	nav_agent.target_position = target_position
	#animation_player.play("run")
 
func animation(_delta):
	if velocity.length() > 0:
		if velocity.x < 0:
			$Sprite2D.flip_h = true
		elif velocity.x > 0:
			$Sprite2D.flip_h = false
