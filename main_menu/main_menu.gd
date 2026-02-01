class_name MainMenu extends Control

@onready var start: Button = %Start
@onready var quit: Button = %Quit
@onready var help: Button = %Help
@onready var hlep: MarginContainer = %Hlep

signal started()

func _on_start_pressed() -> void:
	Global.contamination = 0
	started.emit()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_help_pressed() -> void:
	hlep.visible = !hlep.visible
