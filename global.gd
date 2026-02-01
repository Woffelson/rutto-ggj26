extends Node

const patients: int = 5
var visited: int = 0:
	set(value):
		visited = value
		if visited >= patients:
			await get_tree().create_timer(5).timeout
			survived.emit()
var cured: int = 0
var contamination: int = 0:
	set(value):
		contamination = value
		if contamination >= 100:
			dieded.emit()
var selected_potion: Potion
var current_house: House
var contamination_delay: float = 1 #for timers (difficulty setting?)
var contamination_heal: int = 5 #successful heal decreases contamination, alt difficulty setting?
var hud: HUD
var player: Player

signal survived()
signal dieded()

func reset() -> void:
	visited = 0
	cured = 0
	contamination = 0
	selected_potion = null
	current_house = null
