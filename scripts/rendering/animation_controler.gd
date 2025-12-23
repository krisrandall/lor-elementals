class_name AnimationController
extends Node

@onready var animated_sprite: AnimatedSprite2D = get_parent().get_node("AnimatedSprite")

var current_direction: String = "south"
var is_moving: bool = false
var is_attacking: bool = false

func _ready():
	if not animated_sprite:
		push_error("AnimatedSprite2D node 'AnimatedSprite' not found!")
		return
	
	play_animation("idle", current_direction)

func update_movement(velocity: Vector2):
	"""Update animation based on movement velocity"""
	if velocity.length() > 0:
		is_moving = true
		current_direction = get_direction_from_velocity(velocity)
		
		if not is_attacking:
			play_animation("walk", current_direction)
	else:
		is_moving = false
		
		if not is_attacking:
			play_animation("idle", current_direction)

func play_attack():
	"""Trigger attack animation"""
	is_attacking = true
	play_animation("attack", current_direction)
	
	await animated_sprite.animation_finished
	is_attacking = false
	
	if is_moving:
		play_animation("walk", current_direction)
	else:
		play_animation("idle", current_direction)

func play_animation(anim_type: String, direction: String):
	"""Play animation with proper naming convention"""
	var anim_name = anim_type + "_" + direction
	
	if animated_sprite.sprite_frames.has_animation(anim_name):
		animated_sprite.play(anim_name)
	else:
		push_warning("Animation not found: " + anim_name)

func get_direction_from_velocity(velocity: Vector2) -> String:
	"""Convert velocity vector to 8-directional string"""
	var angle = velocity.angle()
	var degrees = rad_to_deg(angle)
	
	if degrees < 0:
		degrees += 360
	
	# Map angle to direction (0° is pointing right/east in Godot)
	if degrees >= 337.5 or degrees < 22.5:
		return "east"
	elif degrees >= 22.5 and degrees < 67.5:
		return "south-east"
	elif degrees >= 67.5 and degrees < 112.5:
		return "south"
	elif degrees >= 112.5 and degrees < 157.5:
		return "south-west"
	elif degrees >= 157.5 and degrees < 202.5:
		return "west"
	elif degrees >= 202.5 and degrees < 247.5:
		return "north-west"
	elif degrees >= 247.5 and degrees < 292.5:
		return "north"
	else:  # 292.5 to 337.5
		return "north-east"