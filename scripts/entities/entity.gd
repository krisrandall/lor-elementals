class_name Entity
extends RefCounted

signal died
signal health_changed(current: float, max: float)

var entity_name: String = "Entity"
var stats: Stats
var blueprint: Blueprint
var inventory: Inventory

func _init(name: String, initial_stats: Stats, bp: Blueprint = null):
	entity_name = name
	stats = initial_stats
	blueprint = bp
	inventory = Inventory.new()

func take_damage(amount: float):
	var is_dead = stats.take_damage(amount)
	health_changed.emit(stats.current_hp, stats.max_hp)
	if is_dead:
		died.emit()

func equip_item(item: Item, slot: BlueprintSlot) -> bool:
	if blueprint and slot in blueprint.slots:
		if slot.equip(item):
			inventory.remove_item(item)
			return true
	return false

func unequip_item(slot: BlueprintSlot) -> Item:
	if blueprint and slot in blueprint.slots:
		var item = slot.unequip()
		if item:
			inventory.add_item(item)
		return item
	return null

func get_equipped_weapons() -> Array[Weapon]:
	var weapons: Array[Weapon] = []
	if blueprint:
		for slot in blueprint.slots:
			if slot.is_filled() and slot.equipped_item is Weapon:
				weapons.append(slot.equipped_item)
	return weapons

func get_total_defense() -> float:
	var total = 0.0
	if blueprint:
		for slot in blueprint.slots:
			if slot.is_filled() and slot.equipped_item is Armor:
				total += slot.equipped_item.defense
	return total

func get_speed_with_modifiers() -> float:
	var base_speed = stats.speed
	var modifier = 0.0
	if blueprint:
		for slot in blueprint.slots:
			if slot.is_filled():
				if slot.equipped_item is Weapon:
					modifier += slot.equipped_item.speed_modifier
				elif slot.equipped_item is Armor:
					modifier += slot.equipped_item.speed_modifier
	return base_speed + modifier
