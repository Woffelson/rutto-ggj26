extends Node2D

@onready var lenses: Node2D = %Lenses

func _physics_process(delta: float) -> void:
	lenses.position = get_global_mouse_position()
