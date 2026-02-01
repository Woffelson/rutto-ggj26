extends Node

const patients: int = 5
var visited: int = 0:
	set(value):
		visited = value
		if visited >= patients:
			survived.emit()
var cured: int = 0
var selected_potion: Potion
var contamination: int = 0:
	set(value):
		contamination = value
		if contamination >= 100:
			dieded.emit()
var contamination_delay: float = 1 #for timers (difficulty setting?)
var contamination_heal: int = 5 #successful heal decreases contamination, alt difficulty setting?
var hud: HUD

signal survived()
signal dieded()
