class_name PotionMenu extends Node2D

var potion_scenes: Array[Potion] #healthy and unhealthy ones
var pick: bool = false

@onready var lenses: Node2D = %Lenses
@onready var potions: Node2D = %Potions
@onready var cough: AudioStreamPlayer = %Cough
@onready var cough_timer: Timer = %CoughTimer
@onready var timer: Timer = Timer.new()
@onready var swipe: AudioStreamPlayer = %Swipe
@onready var colorrekt: ColorRect = %ColorRect
@onready var outside: Area2D = %Outside
@onready var hint_tween: Tween = get_tree().create_tween().set_loops()
@onready var potion_scene_paths: Array[PackedScene] = [
	preload("res://inventory/potions/berries.tscn"),
	preload("res://inventory/potions/bottle.tscn"),
	preload("res://inventory/potions/onion.tscn"),
	preload("res://inventory/potions/sieni.tscn"),
	preload("res://inventory/potions/worms.tscn"),
]

signal medicine_chosen(type: Potion.Type, healthy: bool)

func _ready() -> void:
	add_child(timer)
	timer.start(Global.contamination_delay)
	timer.timeout.connect(func(): Global.contamination += 1)
	cough_timer.wait_time = randi_range(5,10)
	for potion_resource: PackedScene in potion_scene_paths:
		potion_scenes.append(potion_resource.instantiate())
	for potion_resource: PackedScene in potion_scene_paths:
		var poison: Potion = potion_resource.instantiate()
		poison.healthy = false
		potion_scenes.append(poison)
	hint_tween.tween_property(colorrekt,"color",Color.DIM_GRAY,0.5).set_trans(Tween.TRANS_SINE)
	hint_tween.tween_property(colorrekt,"color",Color.BLACK,0.5).set_trans(Tween.TRANS_SINE)
	hint_tween.stop()

func _enter_tree() -> void:
	await get_tree().process_frame
	swipe.play()
	set_potions()
	hint_tween.stop()

func set_potions() -> void:
	if potions.get_child_count() > 0:
		for potion: Potion in potions.get_children(): potions.remove_child(potion)
	potion_scenes.shuffle()
	for potion: int in potion_scenes.size(): #potions.get_children():
		var xx: int = 240*(potion+1)+222
		var yy: int = 256
		if potion > 4:
			xx = 240*(potion+1-5)+222
			yy = 550
		if potion_scenes[potion].get_parent():
			potion_scenes[potion].reparent(potions) #bug fix
		else:
			potions.add_child(potion_scenes[potion])
		potion_scenes[potion].position = Vector2(xx,yy)
		potion_scenes[potion].modulate = Color.from_hsv(randf(), randf_range(0.0,0.3), 1)
		if !potion_scenes[potion].selected.is_connected(get_potion):
			potion_scenes[potion].selected.connect(get_potion)

func _physics_process(_delta: float) -> void:
	lenses.position = get_global_mouse_position()
	if Input.is_action_just_pressed("mb_left") && pick:
		Global.selected_potion.reparent(potions) #items persist
		medicine_chosen.emit(Global.selected_potion.type,Global.selected_potion.healthy)
		#potion_scenes.erase(Global.selected_potion) #items are...
		#Global.selected_potion.queue_free() #...used
		Global.selected_potion = null
		await get_tree().process_frame
		disable_pick()
	if Global.selected_potion != null && !pick: hint_tween.play()
	elif Global.selected_potion == null:
		hint_tween.stop()
		colorrekt.color = Color.BLACK
	else: hint_tween.stop()

func get_potion(current_potion: Potion) -> void:
	#for potion: Potion in potions.get_children():
		#potion.show()
	for grabbed_potion: Node2D in lenses.get_children():
		if grabbed_potion is Potion:
			grabbed_potion.process_mode = Node.PROCESS_MODE_INHERIT
			grabbed_potion.reparent(potions)
			#print((grabbed_potion as Potion).start_position)
			#grabbed_potion.position = (grabbed_potion as Potion).start_position #not wurkin
	Global.selected_potion = current_potion
	current_potion.reparent(lenses)
	current_potion.process_mode = Node.PROCESS_MODE_DISABLED

func disable_pick() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(colorrekt,"color",Color.BLACK,0.1).set_trans(Tween.TRANS_SINE)
	pick = false

func _on_cough_timer_timeout() -> void:
	cough.play()
	cough_timer.wait_time = randi_range(5,10)

func _on_outside_area_entered(_area: Area2D) -> void:
	if Global.selected_potion != null:
		var tween: Tween = create_tween()
		tween.tween_property(colorrekt,"color",Color.WHITE,0.5).set_trans(Tween.TRANS_SINE)
		pick = true
	Global.hud.back.show()

func _on_outside_area_exited(_area: Area2D) -> void:
	disable_pick()
	Global.hud.back.hide()
