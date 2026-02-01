class_name House extends Area2D

enum Sickness {COUGH,SNIFF,HICKUP,VOIVOI,DYING}

@export var sickness: Sickness = Sickness.COUGH

var dealt: bool = false

@onready var door: Sprite2D = %Door
@onready var og_scale_x: float = door.scale.x
@onready var sicko: Sprite2D = %Sairas
@onready var sicko_scale: Vector2 = sicko.scale
@onready var door_sfx: Node2D 
@onready var timer: Timer = Timer.new()
@onready var heal_partikles: Node2D = preload("res://map/gfx/Healparticle.tscn").instantiate()
@onready var skull_partikles: Node2D = preload("res://map/gfx/Skullparticle.tscn").instantiate()

signal moved_near(in_or_out: bool)

func _ready() -> void:
	add_child(timer)
	timer.wait_time = Global.contamination_delay
	timer.timeout.connect(func(): if !dealt: Global.contamination += 1)

func _enter_tree() -> void: #hnnghh (this should probably help with reattaching disabled signals)
	if !body_entered.is_connected(_on_body_entered): body_entered.connect(_on_body_entered)
	if !body_exited.is_connected(_on_body_exited): body_exited.connect(_on_body_exited)

func _exit_tree() -> void: #I don't want these working when exiting!
	body_entered.disconnect(_on_body_entered)
	body_exited.disconnect(_on_body_exited)

func _physics_process(_delta: float) -> void:
	if sicko_scale == Vector2.ZERO: sicko.hide()
	#if Input.is_action_just_pressed("ui_focus_next") && sickness == Sickness.SNIFF: #DEBUG
		#visit(Potion.Type.ONION,true)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		timer.start()
		moved_near.emit(true)
		if !dealt:
			door_animation(-og_scale_x)
			sicko.show()
			sicko.scale = Vector2.ZERO
			var tween: Tween = create_tween()
			tween.tween_property(sicko,"scale",sicko_scale,0.75).set_trans(Tween.TRANS_SINE)
			Global.hud.briefcase.show()
			Global.current_house = self

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		timer.stop()
		moved_near.emit(false)
		door_animation(og_scale_x)
		var tween: Tween = create_tween()
		tween.tween_property(sicko,"scale",Vector2.ZERO,0.75).set_trans(Tween.TRANS_SINE)
		Global.hud.briefcase.hide()
		Global.current_house = null

func door_animation(scl: float) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(door,"scale:x",scl,1).set_trans(Tween.TRANS_SINE)

func visit(type: Potion.Type, healthy: bool) -> void:
	if !dealt:
		if ((sickness == Sickness.COUGH && type == Potion.Type.BOTTLE) ||\
			(sickness == Sickness.SNIFF && type == Potion.Type.ONION) ||\
			(sickness == Sickness.HICKUP && type == Potion.Type.BERRIES) ||\
			(sickness == Sickness.VOIVOI && type == Potion.Type.MUSHROOM) ||\
			(sickness == Sickness.DYING && type == Potion.Type.WORMS)) && healthy:
			door.add_child(heal_partikles)
			heal_partikles.get_child(0).emitting = true
			Global.cured += 1
			Global.contamination -= 5 #reward
		else:
			door.add_child(skull_partikles)
			skull_partikles.get_child(0).emitting = true
			Global.contamination += 5 #punishment
		dealt = true
		Global.visited += 1
		#Global.player.stopping = true #I want this working but I probably cannot...
