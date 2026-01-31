class_name Potion extends Area2D

enum Type {BOTTLE_A, BOTTLE_B, MUSHROOM, WORMS, ONION, BERRIES}

@export var type: Type

signal selected(p: Potion)

var preselection: bool = false

func _physics_process(_delta: float) -> void:
	if preselection && Input.is_action_just_pressed("mb_left"):
		selected.emit(self)

func _on_mouse_entered() -> void:
	preselection = true

func _on_mouse_exited() -> void:
	preselection = false
