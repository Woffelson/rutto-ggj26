extends Sprite2D

@onready var og_scale: Vector2 = scale

func _ready() -> void:
	var tween: Tween = create_tween().set_loops()
	tween.tween_property(self,"scale",og_scale+(Vector2(0.1,-0.1)),1)
	tween.tween_property(self,"scale",scale+(Vector2(-0.1,0.1)),1)
