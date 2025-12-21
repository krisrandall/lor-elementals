class_name BlueprintSlot
extends RefCounted

var slot_name: String = "Slot"
var required_item_type: GameEnums.ItemType = GameEnums.ItemType.GENERIC
var required_element: GameEnums.ElementType = GameEnums.ElementType.NONE  # NONE means any element
var equipped_item: Item = null

func _init(name: String, item_type: GameEnums.ItemType, element: GameEnums.ElementType = GameEnums.ElementType.NONE):
	slot_name = name
	required_item_type = item_type
	required_element = element

func can_equip(item: Item) -> bool:
	if item.item_type != required_item_type:
		return false
	if required_element != GameEnums.ElementType.NONE and item.element_type != required_element:
		return false
	return true

func equip(item: Item) -> bool:
	if can_equip(item):
		equipped_item = item
		return true
	return false

func unequip() -> Item:
	var item = equipped_item
	equipped_item = null
	return item

func is_filled() -> bool:
	return equipped_item != null
