class_name HUD extends CanvasLayer

@onready var contamination_bar: TextureProgressBar = %ContaminationBar
@onready var back: Label = %Back

signal switched_to_map()

func _ready() -> void:
	Global.hud = self

func _physics_process(_delta: float) -> void:
	contamination_bar.value = Global.contamination
	if back.visible && (Input.is_action_just_pressed("ui_accept") || \
		Input.is_action_just_pressed("mb_left")):
		Global.selected_potion = null #potion menu bug fix... this thing makes me crazy...
		switched_to_map.emit()
