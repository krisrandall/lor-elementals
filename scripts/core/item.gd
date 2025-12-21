class_name Item
extends RefCounted

var item_name: String = "Item"
var item_type: GameEnums.ItemType = GameEnums.ItemType.GENERIC
var element_type: GameEnums.ElementType = GameEnums.ElementType.NONE

func _init(name: String = "Item", type: GameEnums.ItemType = GameEnums.ItemType.GENERIC, element: GameEnums.ElementType = GameEnums.ElementType.NONE):
	item_name = name
	item_type = type
	element_type = element
