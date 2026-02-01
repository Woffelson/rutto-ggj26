class_name Ending extends Control

@export var survived: bool = true
@onready var results_label: Label = %Results

signal restarted()

func _ready() -> void:
	results_label.text = "You cured " + str(Global.cured) + " poor souls out of " + \
	str(Global.visited) + " sickened.\n" 
	if survived:
		results_label.text += "For now, you remain alive—until you are the weakened."
		await get_tree().create_timer(5).timeout
		$AudioStreamPlayer.play()
	else: results_label.text += "Then you joined the dead and the wicked."

func _on_button_pressed() -> void:
	restarted.emit()
