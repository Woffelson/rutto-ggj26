class_name PotionMenu extends Node2D

@onready var lenses: Node2D = %Lenses
@onready var potions: Node2D = %Potions
@onready var cough: AudioStreamPlayer = %Cough
@onready var timer: Timer = %Timer
@onready var potion_scenes: Array[Potion] = [
	preload("res://inventory/potions/berries.tscn").instantiate(),
	preload("res://inventory/potions/bottle.tscn").instantiate(),
	preload("res://inventory/potions/onion.tscn").instantiate(),
	preload("res://inventory/potions/sieni.tscn").instantiate(),
	preload("res://inventory/potions/worms.tscn").instantiate(),
]

func _ready() -> void:
	timer.wait_time = randi_range(5,10)

func _enter_tree() -> void:
	await get_tree().process_frame
	set_potions()

func set_potions() -> void:
	if potions.get_child_count() > 0:
		for potion: Potion in potions.get_children(): potions.remove_child(potion)
	potion_scenes.shuffle()
	for potion: int in potion_scenes.size(): #potions.get_children():
		var xx: int = 256*(potion+1)+256
		var yy: int = 256
		if potion > 3:
			xx = 256*(potion+1-4)+256
			yy = 550
		potion_scenes[potion].position = Vector2(xx,yy)
		potions.add_child(potion_scenes[potion])
		if !potion_scenes[potion].selected.is_connected(get_potion):
			potion_scenes[potion].selected.connect(get_potion)

func _physics_process(_delta: float) -> void:
	lenses.position = get_global_mouse_position()

func get_potion(current_potion: Potion) -> void:
	for potion: Potion in potions.get_children():
		potion.show()
	Global.selected_potion = current_potion
	current_potion.hide()

func _on_timer_timeout() -> void:
	cough.play()
	timer.wait_time = randi_range(5,10)
