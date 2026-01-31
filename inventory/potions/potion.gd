class_name Potion extends Area2D

enum Type {BOTTLE, MUSHROOM, WORMS, ONION, BERRIES}

@export var type: Type
var healthy: bool = true

var healthy_texts: Dictionary[Type,String] = {
	Type.BOTTLE: "Instant relief for\ncough",
	Type.MUSHROOM: "Does cure\nsuffering",
	Type.WORMS: "Leeches to heal mortal wounds",
	Type.ONION: "Onions to mend runny nose",
	Type.BERRIES: "Berries that\ncure hiccups",
}
var unhealthy_texts: Dictionary[Type,String] = {
	Type.BOTTLE: "Instantly causes\ncough",
	Type.MUSHROOM: "Does not cure\nsuffering",
	Type.WORMS: "Snails to cause mortal wounds",
	Type.ONION: "Red onions to mend\nfunny nose",
	Type.BERRIES: "Berries that\nlure hiccups",
}

@onready var label: Label = %Label

signal selected(p: Potion)

var preselection: bool = false

func _ready() -> void:
	if healthy: label.text = healthy_texts[type]
	else: label.text = unhealthy_texts[type]

func _physics_process(_delta: float) -> void:
	if preselection && Input.is_action_just_pressed("mb_left"):
		selected.emit(self)

func _on_mouse_entered() -> void:
	preselection = true

func _on_mouse_exited() -> void:
	preselection = false
