class_name House extends Area2D

enum Sickness {COUGH,SNIFF,HICKUP,VOIVOI,DYING}

@export var sickness: Sickness = Sickness.COUGH

var dealt: bool = false

@onready var door: Sprite2D = %Door
@onready var og_scale_x: float = door.scale.x
@onready var sicko: Sprite2D = %Sairas
@onready var sicko_scale: Vector2 = sicko.scale
@onready var door_sfx: Node2D = preload("res://map/door_sfx.tscn").instantiate()
@onready var sick_sfx: AudioStreamPlayer2D = %Sickness
@onready var yap_sfx: AudioStreamPlayer2D = %Yap
@onready var thx_sfx: AudioStreamPlayer2D = %Kthx
@onready var timer: Timer = Timer.new()
@onready var sfx_timer: Timer = Timer.new()
@onready var heal_partikles: Node2D = preload("res://map/gfx/Healparticle.tscn").instantiate()
@onready var skull_partikles: Node2D = preload("res://map/gfx/Skullparticle.tscn").instantiate()

signal moved_near(in_or_out: bool)

func _ready() -> void:
	sick_sfx.max_distance = 512
	yap_sfx.max_distance = 512
	thx_sfx.max_distance = 512
	add_child(door_sfx)
	add_child(timer)
	add_child(sfx_timer)
	sfx_timer.timeout.connect(random_sfx)
	sfx_timer.start(1.0)
	timer.wait_time = Global.contamination_delay
	timer.timeout.connect(func(): if !dealt: Global.contamination += 1)

func _enter_tree() -> void: #hnnghh (this should probably help with reattaching disabled signals)
	if !body_entered.is_connected(_on_body_entered): body_entered.connect(_on_body_entered)
	if !body_exited.is_connected(_on_body_exited): body_exited.connect(_on_body_exited)

func _exit_tree() -> void: #I don't want these working when exiting!
	body_entered.disconnect(_on_body_entered)
	body_exited.disconnect(_on_body_exited)

func _physics_process(_delta: float) -> void:
	if sicko.scale == Vector2.ZERO:
		sicko.hide()
		sick_sfx.bus = "drSFX"
		yap_sfx.bus = "drSFX"
		thx_sfx.bus = "drSFX"
	else:
		sick_sfx.bus = "MapSFX"
		yap_sfx.bus = "MapSFX"
		thx_sfx.bus = "MapSFX"
	#if Input.is_action_just_pressed("ui_focus_next") && sickness == Sickness.SNIFF: #DEBUG
		#visit(Potion.Type.ONION,true)

func random_sfx() -> void:
	if randf() > 0.75:
		yap_sfx.stop()
		sick_sfx.play()
	elif sicko.visible:
		sick_sfx.stop()
		yap_sfx.play()
	sfx_timer.wait_time = randf_range(0.2,1.5)
	sfx_timer.start()

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
			door_sfx.open.play()

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		timer.stop()
		moved_near.emit(false)
		door_animation(og_scale_x)
		var tween: Tween = create_tween()
		tween.tween_property(sicko,"scale",Vector2.ZERO,0.75).set_trans(Tween.TRANS_SINE)
		Global.hud.briefcase.hide()
		Global.current_house = null
		await get_tree().create_timer(1.0).timeout
		door_sfx.close.play()

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
			Global.contamination -= Global.contamination_heal #reward
			sick_sfx.volume_db = -48
			yap_sfx.volume_db = -48
		else:
			door.add_child(skull_partikles)
			skull_partikles.get_child(0).emitting = true
			Global.contamination += Global.contamination_heal #punishment
			sick_sfx.volume_db = -48
			yap_sfx.volume_db = -48
			
		dealt = true
		Global.visited += 1
		#Global.player.stopping = true #I want this working but I probably cannot...
