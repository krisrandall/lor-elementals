class_name Armor
extends Item

var defense: float = 5.0
var speed_modifier: float = 0.0

func _init(name: String = "Armor", element: GameEnums.ElementType = GameEnums.ElementType.NONE):
	super._init(name, GameEnums.ItemType.ARMOR, element)
