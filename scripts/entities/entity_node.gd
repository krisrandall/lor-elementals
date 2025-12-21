class_name EntityNode
extends CharacterBody2D

@export var entity_data: Entity
@onready var sprite: ColorRect = $Sprite
@onready var health_bar: ProgressBar = $HealthBar

var last_attack_time: float = 0.0

func _ready():
	if entity_data:
		entity_data.health_changed.connect(_on_health_changed)
		entity_data.died.connect(_on_died)
		_update_health_bar()

func _on_health_changed(current: float, max_hp: float):
	_update_health_bar()

func _update_health_bar():
	if health_bar and entity_data:
		health_bar.value = entity_data.stats.get_hp_percent() * 100

func _on_died():
	queue_free()

func can_attack() -> bool:
	if entity_data:
		var weapons = entity_data.get_equipped_weapons()
		if weapons.size() > 0:
			var weapon = weapons[0]
			var time_since_last = Time.get_ticks_msec() / 1000.0 - last_attack_time
			return time_since_last >= (1.0 / weapon.attack_speed)
	return false

func attack(target: EntityNode) -> bool:
	if not can_attack():
		return false
		
	if entity_data:
		var weapons = entity_data.get_equipped_weapons()
		if weapons.size() > 0:
			var weapon = weapons[0]
			var distance = global_position.distance_to(target.global_position)
			
			if distance <= weapon.attack_range:
				target.entity_data.take_damage(weapon.damage)
				last_attack_time = Time.get_ticks_msec() / 1000.0
				return true
	return false
