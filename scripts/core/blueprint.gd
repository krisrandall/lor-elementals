class_name Blueprint
extends RefCounted

var blueprint_name: String = "Blueprint"
var entity_type: GameEnums.EntityType = GameEnums.EntityType.CHARACTER
var slots: Array[BlueprintSlot] = []

func _init(name: String, type: GameEnums.EntityType):
	blueprint_name = name
	entity_type = type

func add_slot(slot: BlueprintSlot):
	slots.append(slot)

func get_slots_of_type(item_type: GameEnums.ItemType) -> Array[BlueprintSlot]:
	var result: Array[BlueprintSlot] = []
	for slot in slots:
		if slot.required_item_type == item_type:
			result.append(slot)
	return result

func is_complete() -> bool:
	for slot in slots:
		if not slot.is_filled():
			return false
	return true

static func create_basic_character() -> Blueprint:
	var bp = Blueprint.new("Basic Character", GameEnums.EntityType.CHARACTER)
	bp.add_slot(BlueprintSlot.new("Primary Weapon", GameEnums.ItemType.WEAPON_HANDHELD))
	bp.add_slot(BlueprintSlot.new("Secondary Weapon", GameEnums.ItemType.WEAPON_HANDHELD))
	bp.add_slot(BlueprintSlot.new("Head Armor", GameEnums.ItemType.ARMOR))
	bp.add_slot(BlueprintSlot.new("Body Armor", GameEnums.ItemType.ARMOR))
	bp.add_slot(BlueprintSlot.new("Leg Armor", GameEnums.ItemType.ARMOR))
	for i in range(6):
		bp.add_slot(BlueprintSlot.new("Accessory %d" % (i + 1), GameEnums.ItemType.WEARABLE))
	return bp

static func create_basic_turret() -> Blueprint:
	var bp = Blueprint.new("Basic Turret", GameEnums.EntityType.TOWER)
	bp.add_slot(BlueprintSlot.new("Turret Gun", GameEnums.ItemType.WEAPON_TURRET))
	bp.add_slot(BlueprintSlot.new("Power Cell", GameEnums.ItemType.POWER_CELL))
	bp.add_slot(BlueprintSlot.new("Tower Base", GameEnums.ItemType.TOWER_BASE))
	return bp
