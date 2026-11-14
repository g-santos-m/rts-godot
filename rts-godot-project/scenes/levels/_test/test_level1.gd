extends Node2D

@onready var castle := $Entities/Buildings/Castle_1


func _ready() -> void:
	$WaveManager.last_wave_ended.connect(_on_last_wave_ended)
	#region TESTS
	#castle.destroyed.connect(_on_castle_destroyed)
	$Hud.clear_enemies.connect(_on_clear_enemies)
	#endregion


#region TESTS
#func _on_castle_destroyed() -> void:
#	$Hud.show_game_over()
#	self.process_mode = Node.PROCESS_MODE_DISABLED


# TODO
func _on_last_wave_ended() -> void:
	pass


func _on_clear_enemies() -> void:
	var enemies: Array[BaseEnemy] = $Entities/Enemies.get_children() as Array[BaseEnemy]
	for enemy in enemies:
		enemy.on_destroyed()
#endregion
