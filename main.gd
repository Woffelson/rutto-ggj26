extends Node

var game_map_path: PackedScene = preload("res://map/game_map.tscn")
var inventory_path: PackedScene = preload("res://inventory/potion_menu.tscn")
var game_map: Node2D
var inventory: PotionMenu

@onready var main_menu: MainMenu = preload("res://main_menu/main_menu.tscn").instantiate()
@onready var hud: HUD = preload("res://hud.tscn").instantiate()
@onready var survive: Ending = preload("res://main_menu/survive.tscn").instantiate()
@onready var died: Ending = preload("res://main_menu/die.tscn").instantiate()

var current_view: Node2D

func _ready() -> void:
	%MenuMusic.play()
	reset_scenes()
	add_child(main_menu)
	main_menu.started.connect(start_game)
	inventory.medicine_chosen.connect(send_medicine)
	survive.restarted.connect(back_to_main_menu)
	died.restarted.connect(back_to_main_menu)
	hud.switched_to_map.connect(switch_view.bind(game_map))
	hud.switched_to_briefcase.connect(switch_view.bind(inventory))
	hud.switched_to_main_menu.connect(back_to_main_menu)
	Global.survived.connect(happy_end)
	Global.dieded.connect(sad_end)

func reset_scenes() -> void:
	game_map = game_map_path.instantiate()
	inventory = inventory_path.instantiate()
	current_view = null

func _input(_event: InputEvent) -> void: #early testing
	#if Input.is_action_just_pressed("ui_accept"):
		#switch_view(inventory)
	#if Input.is_action_just_pressed("ui_focus_next"):
		#switch_view(game_map)
	if Input.is_action_just_pressed("ui_cancel"):
		back_to_main_menu()

func start_game() -> void:
	if main_menu.is_inside_tree(): remove_child(main_menu)
	add_child(game_map)
	add_child(hud)
	current_view = game_map
	hud.on_map = true
	mute_music()
	%BGMusic.play()

func switch_view(new_view: Node2D) -> void:
	if current_view != new_view:
		remove_child(current_view)
		add_child(new_view)
		current_view = new_view

func back_to_main_menu() -> void:
	Global.reset()
	get_tree().reload_current_scene()

func send_medicine(type: Potion.Type, healthy: bool) -> void:
	if Global.current_house != null:
		Global.current_house.visit(type,healthy)

func happy_end() -> void:
	game_map.queue_free()
	inventory.queue_free()
	remove_child(hud)
	#reset_scenes()
	add_child(survive)
	mute_music()
	%Fanfare.play()

func sad_end() -> void:
	game_map.queue_free()
	inventory.queue_free()
	remove_child(hud)
	add_child(died)
	mute_music()
	%Failfare.play()

func mute_music() -> void:
	for child: AudioStreamPlayer in %Music.get_children():
		child.stop()
