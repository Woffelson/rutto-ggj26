class_name Player extends CharacterBody2D

@export var speed: float = 300
@export var acceleration: float = 200
@export var friction: float = 40
var hor_ctrl: float = 0.0
var ver_ctrl: float = 0.0
var facing: Vector2i = Vector2i(1,1)
var target_position: Vector2 #mouse clicked target movemement
var following = false #following mouse clicked position

@onready var camera: Camera2D = %Camera
@onready var animu_spr: AnimatedSprite2D = %Animu

func _physics_process(delta: float) -> void:
	hor_ctrl = Input.get_axis("key_left","key_right")
	ver_ctrl = Input.get_axis("key_up","key_down")
	if abs(hor_ctrl) > 0:
		facing.x = sign(hor_ctrl)
		if ver_ctrl == 0: facing.y = 0
		animu_spr.flip_h = bool(min(0,-hor_ctrl))
	if abs(ver_ctrl) > 0:
		facing.y = sign(ver_ctrl)
		if hor_ctrl == 0: facing.x = sign(facing.x)*0.5
	if Input.get_axis("key_left","key_right") != 0 || Input.get_axis("key_up","key_down") != 0:
		following = false #disabling mouse movement when moving with keys
	if following && abs(target_position.length() - position.length()) > 32: #experimental mouse movement
		hor_ctrl = target_position.x - position.x
		ver_ctrl = target_position.y - position.y
	velocity = move(velocity * (delta * 60),hor_ctrl,ver_ctrl)
	if velocity.length() > 0: animu_spr.play("walk")
	else: animu_spr.play("idle")
	move_and_slide()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("mb_left"):
		following = true
		target_position = get_global_mouse_position()

func move(velocityxy: Vector2,horizontal_direction: float = 0.0,vertical_direction: float = 0.0) -> Vector2:
	if horizontal_direction || vertical_direction:
		var direction_vector: Vector2 = Vector2(horizontal_direction,vertical_direction) #raw directions
		direction_vector = Vector2(horizontal_direction,vertical_direction).normalized()
		return velocityxy.move_toward(direction_vector * speed,acceleration)
	else: return velocityxy.move_toward(Vector2.ZERO,friction)

func camera_zoom(in_or_out: bool) -> void:
	var tween: Tween = create_tween()
	if in_or_out:
		tween.tween_property(camera,"zoom",Vector2(2,2),1.5).set_trans(Tween.TRANS_SINE)
	else: tween.tween_property(camera,"zoom",Vector2(1,1),1.5).set_trans(Tween.TRANS_SINE)
