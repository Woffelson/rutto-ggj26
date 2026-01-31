class_name House extends Area2D

@onready var door: Sprite2D = %Door
@onready var og_scale_x: float = door.scale.x

signal moved_near(in_or_out: bool)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		moved_near.emit(true)
		door_animation(-og_scale_x)

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		moved_near.emit(false)
		door_animation(og_scale_x)

func door_animation(scl: float) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(door,"scale:x",scl,1).set_trans(Tween.TRANS_SINE)
