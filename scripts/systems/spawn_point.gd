class_name SpawnPoint
extends Node2D

@export var spawn_interval: float = 3.0
@export var enemy_scene: PackedScene

var home_castle: EntityNode = null
var spawn_timer: float = 0.0
var is_active: bool = true

func _ready():
	if not enemy_scene:
		enemy_scene = preload("res://scenes/enemy_character.tscn")

func _process(delta):
	if not is_active or not home_castle:
		return
	
	spawn_timer += delta
	if spawn_timer >= spawn_interval:
		spawn_enemy()
		spawn_timer = 0.0

func spawn_enemy():
	if not enemy_scene:
		return
	
	var enemy = enemy_scene.instantiate()
	get_parent().add_child(enemy)
	enemy.global_position = global_position
	
	if enemy is EnemyCharacter and home_castle:
		enemy.set_target(home_castle)

func set_home_castle(castle: EntityNode):
	home_castle = castle
