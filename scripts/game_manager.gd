class_name GameManager
extends Node

@onready var player: PlayerCharacter = $Player
@onready var home_castle: HomeCastle = $HomeCastle
@onready var spawn_points: Array[Node] = []

func _ready():
	# Find all spawn points
	for child in get_children():
		if child is SpawnPoint:
			spawn_points.append(child)
			child.set_home_castle(home_castle)

func _input(event):
	# Handle touch/click movement
	if event is InputEventScreenTouch:
		if event.pressed:
			player.set_move_target(event.position)
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			player.set_move_target(get_viewport().get_mouse_position())
