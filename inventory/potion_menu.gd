class_name PotionMenu extends Node2D

@onready var lenses: Node2D = %Lenses
@onready var potions: Node2D = %Potions

func _ready() -> void:
	for potion: Potion in potions.get_children():
		potion.selected.connect(get_potion)

func _physics_process(_delta: float) -> void:
	lenses.position = get_global_mouse_position()

func get_potion(current_potion: Potion) -> void:
	for potion: Potion in potions.get_children():
		potion.show()
	Global.selected_potion = current_potion
	current_potion.hide()
