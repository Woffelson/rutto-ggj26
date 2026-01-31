class_name Potion extends Area2D

enum Type {BOTTLE_A, BOTTLE_B, MUSHROOM_A, MUSHROOM_B, WORMS_A, WORMS_B, ONION_A, ONION_B, BERRIES_A, BERRIES_B}

@export var type: Type
var texts: Dictionary[Type,String] = {
	Type.BOTTLE_A: "Tincture to cure\ncough and pleghm",
	Type.BOTTLE_B: "",
	Type.MUSHROOM_A: "A soothing\ntrip to calm\npain-ridden\nnerves",
	Type.MUSHROOM_B: "",
	Type.WORMS_A: "Instant relief for those on their last legs, suffering from mortal wounds and other ailments",
	Type.WORMS_B: "",
	Type.ONION_A: "For use against sniffles and flu",
	Type.ONION_B: "",
	Type.BERRIES_A: "Certain relief\nagainst hiccup",
	Type.BERRIES_B: "",
}

signal selected(p: Potion)

var preselection: bool = false

func _physics_process(_delta: float) -> void:
	if preselection && Input.is_action_just_pressed("mb_left"):
		selected.emit(self)

func _on_mouse_entered() -> void:
	preselection = true

func _on_mouse_exited() -> void:
	preselection = false
