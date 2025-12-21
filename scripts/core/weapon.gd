class_name Weapon
extends Item

var damage: float = 10.0
var attack_range: float = 50.0
var attack_speed: float = 1.0  # attacks per second
var speed_modifier: float = 0.0  # positive = faster, negative = slower

func _init(name: String = "Weapon", type: GameEnums.ItemType = GameEnums.ItemType.WEAPON_HANDHELD, element: GameEnums.ElementType = GameEnums.ElementType.NONE):
	super._init(name, type, element)
	
static func create_basic_sword() -> Weapon:
	var sword = Weapon.new("Basic Sword", GameEnums.ItemType.WEAPON_HANDHELD, GameEnums.ElementType.NONE)
	sword.damage = 15.0
	sword.attack_range = 40.0
	sword.attack_speed = 1.5
	sword.speed_modifier = 0.0
	return sword
