class_name Stats
extends RefCounted

var max_hp: float = 100.0
var current_hp: float = 100.0
var damage: float = 10.0
var speed: float = 100.0  # pixels per second

func _init(hp: float = 100.0, dmg: float = 10.0, spd: float = 100.0):
	max_hp = hp
	current_hp = hp
	damage = dmg
	speed = spd

func take_damage(amount: float) -> bool:
	current_hp = max(0, current_hp - amount)
	return current_hp <= 0  # returns true if dead

func heal(amount: float):
	current_hp = min(max_hp, current_hp + amount)

func is_alive() -> bool:
	return current_hp > 0

func get_hp_percent() -> float:
	return current_hp / max_hp if max_hp > 0 else 0.0
