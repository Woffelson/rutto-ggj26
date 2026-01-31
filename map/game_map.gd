extends Node2D

@onready var player: Player = %Player
@onready var houses: Node2D = %Houses

func _ready() -> void:
	for house: House in houses.get_children():
		house.moved_near.connect(player.camera_zoom)
		#print(house.moved_near.is_connected(player.camera_zoom))
