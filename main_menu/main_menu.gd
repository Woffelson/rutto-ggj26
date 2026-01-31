class_name MainMenu extends Control

@onready var start: Button = %Start
@onready var quit: Button = %Quit

signal started()

func _on_start_pressed() -> void:
	started.emit()

func _on_quit_pressed() -> void:
	get_tree().quit()
