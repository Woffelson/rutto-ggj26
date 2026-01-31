extends Node

var game_map_path: PackedScene = preload("res://map/game_map.tscn")
var inventory_path: PackedScene = preload("res://inventory/potion_menu.tscn")
var game_map: Node2D
var inventory: PotionMenu

@onready var main_menu: MainMenu = preload("res://main_menu/main_menu.tscn").instantiate()

var current_view: Node2D

func _ready() -> void:
	reset_scenes()
	add_child(main_menu)
	main_menu.started.connect(start_game)

func reset_scenes() -> void:
	game_map = game_map_path.instantiate()
	inventory = inventory_path.instantiate()
	current_view = null

func _input(_event: InputEvent) -> void: #TODO tmp solutions, needs GUI?
	if Input.is_action_just_pressed("ui_accept"):
		switch_view(inventory)
	if Input.is_action_just_pressed("ui_focus_next"):
		switch_view(game_map)
	if Input.is_action_just_pressed("ui_cancel"):
		back_to_main_menu()

func start_game() -> void:
	if main_menu.is_inside_tree(): remove_child(main_menu)
	add_child(game_map)
	current_view = game_map

func switch_view(new_view: Node2D) -> void:
	if current_view != new_view:
		remove_child(current_view)
		add_child(new_view)
		current_view = new_view

func back_to_main_menu() -> void:
	game_map.queue_free()
	inventory.queue_free()
	reset_scenes()
	add_child(main_menu)
	
