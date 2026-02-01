class_name Ending extends Control

signal restarted()

func _on_button_pressed() -> void:
	restarted.emit()
