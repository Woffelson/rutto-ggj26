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
	for potion: int in potion_scenes.size()-1: #potions.get_children():
		potion_scenes[potion].position = Vector2(256*(potion+1)+256,256)
		potions.add_child(potion_scenes[potion])
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
