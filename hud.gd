class_name HUD extends CanvasLayer

@onready var contamination_bar: TextureProgressBar = %ContaminationBar

func _ready() -> void:
	Global.hud = self

func _physics_process(_delta: float) -> void:
	contamination_bar.value = Global.contamination
