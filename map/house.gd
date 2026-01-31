class_name House extends Area2D

@onready var door: Sprite2D = %Door
@onready var og_scale_x: float = door.scale.x
@onready var sicko: Sprite2D = %Sairas
@onready var sicko_scale: Vector2 = sicko.scale

signal moved_near(in_or_out: bool)

func _physics_process(_delta: float) -> void:
	if sicko_scale == Vector2.ZERO: sicko.hide()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		moved_near.emit(true)
		door_animation(-og_scale_x)
		sicko.show()
		sicko.scale = Vector2.ZERO
		var tween: Tween = create_tween()
		tween.tween_property(sicko,"scale",sicko_scale,0.75).set_trans(Tween.TRANS_SINE)

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		moved_near.emit(false)
		door_animation(og_scale_x)
		var tween: Tween = create_tween()
		tween.tween_property(sicko,"scale",Vector2.ZERO,0.75).set_trans(Tween.TRANS_SINE)

func door_animation(scl: float) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(door,"scale:x",scl,1).set_trans(Tween.TRANS_SINE)
