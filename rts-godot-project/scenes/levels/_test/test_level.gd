extends Node2D

signal back_to_menu

@onready var castle := $Entities/Buildings/Castle_1


func _ready() -> void:
	$WaveManager.last_wave_ended.connect(_on_last_wave_ended)
	$Hud.back_to_menu.connect(_on_back_to_menu)
	#region TESTS
	#castle.destroyed.connect(_on_castle_destroyed)
	$Hud.clear_enemies.connect(_on_clear_enemies)
	#endregion


func _on_back_to_menu() -> void:
	back_to_menu.emit()
	_reset_ids()
	queue_free()


# TODO
func _on_last_wave_ended() -> void:
	pass

func _reset_ids() -> void:
	BaseUnit.reset_ids()
	BaseBuilding.reset_ids()
	BaseEnemy.reset_ids()

#region TESTS
#func _on_castle_destroyed() -> void:
#	$Hud.show_game_over()
#	self.process_mode = Node.PROCESS_MODE_DISABLED


func _on_clear_enemies() -> void:
	var enemies: Array[BaseEnemy] = $Entities/Enemies.get_children() as Array[BaseEnemy]
	for enemy in enemies:
		enemy.on_destroyed()
#endregion
