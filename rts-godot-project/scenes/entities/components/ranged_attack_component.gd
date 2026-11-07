extends AttackComponent

var projectile_scene: PackedScene

func attack_target(target: PhysicsBody2D) -> void:
	if not _on_cooldown:
		var direction: Vector2 = global_position.direction_to(target.global_position)
		var projectile: Node2D = projectile_scene.instantiate()
		projectile.setup(direction, _attack_damage, _printer)
		projectile.global_position = get_parent().global_position
		projectile.rotation = global_position.angle_to_point(target.global_position)
		add_child(projectile)
		_printer.cprint("is attacking ", target.name)

		_on_cooldown = true
		_timer.start(_attack_rate)
