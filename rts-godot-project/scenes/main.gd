extends Node2D

var menu_screen_scene := preload("res://scenes/ui/views/menu_screen.tscn")
var level_1_scene := preload("res://scenes/levels/level_1.tscn")
var test_level_scene := preload("res://scenes/levels/_test/test_level.tscn")

var _menu_screen: CanvasLayer
var _level: Node2D

@onready var _printer: Printer = Printer.new(name)

func _ready() -> void:
	_printer.cprint("game initiated")
	_on_back_to_menu()

func _on_start_game() -> void:
	#_level = level_1_scene.instantiate()
	_level = test_level_scene.instantiate()
	_level.back_to_menu.connect(_on_back_to_menu)
	add_child(_level)
	_printer.cprint("level screen on view")

func _on_back_to_menu() -> void:
	_menu_screen = menu_screen_scene.instantiate()
	_menu_screen.start_game.connect(_on_start_game)
	add_child(_menu_screen)
	_printer.cprint("menu screen on view")
