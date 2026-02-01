class_name HUD extends CanvasLayer

var on_map: bool = false

@onready var contamination_bar: TextureProgressBar = %ContaminationBar
@onready var back: Label = %Back
@onready var briefcase: Button = %Briefcase

signal switched_to_map()
signal switched_to_briefcase()
signal switched_to_main_menu()

func _ready() -> void:
	Global.hud = self

func _physics_process(_delta: float) -> void:
	contamination_bar.value = Global.contamination
	if back.visible && (Input.is_action_just_pressed("ui_accept") || \
		Input.is_action_just_pressed("mb_left")):
		back_to_map()

func back_to_map() -> void: #for some reason this is always full of issues and complications...
	await get_tree().process_frame #wait a bit
	briefcase.text = "Open Briefcase"
	Global.selected_potion = null #potion menu bug fix... this thing made me crazy...
	switched_to_map.emit()

func _on_to_menu_pressed() -> void:
	switched_to_main_menu.emit()

func _on_briefcase_pressed() -> void:
	if on_map:
		briefcase.hide()
		#briefcase.text = "Close Briefcase"
		switched_to_briefcase.emit()
	else: #if hidden, obsolete
		back_to_map()
