class_name Inventory
extends RefCounted

var items: Array[Item] = []
var max_size: int = 20

func add_item(item: Item) -> bool:
	if items.size() < max_size:
		items.append(item)
		return true
	return false

func remove_item(item: Item) -> bool:
	var idx = items.find(item)
	if idx >= 0:
		items.remove_at(idx)
		return true
	return false

func has_item(item: Item) -> bool:
	return items.has(item)

func get_items_of_type(type: GameEnums.ItemType) -> Array[Item]:
	var result: Array[Item] = []
	for item in items:
		if item.item_type == type:
			result.append(item)
	return result
