class_name EnemyCharacter
extends EntityNode

var target: EntityNode = null
var path: Array[Vector2] = []
var path_index: int = 0
var last_pathfind_time: float = 0.0
var pathfind_interval: float = 0.5

func _ready():
	super._ready()
	
	# Create basic enemy
	var enemy_stats = Stats.new(30.0, 5.0, 80.0)
	entity_data = Entity.new("Basic Enemy", enemy_stats)
	
	# Give enemy a basic attack weapon
	var claw = Weapon.new("Claws", GameEnums.ItemType.WEAPON_HANDHELD, GameEnums.ElementType.NONE)
	claw.damage = 5.0
	# NB: range must be greater than the size of the home castle distance from its center to its walls 
	claw.attack_range = 60.0
	claw.attack_speed = 1.0
	
	var simple_blueprint = Blueprint.new("Enemy", GameEnums.EntityType.CHARACTER)
	simple_blueprint.add_slot(BlueprintSlot.new("Weapon", GameEnums.ItemType.WEAPON_HANDHELD))
	entity_data.blueprint = simple_blueprint
	entity_data.inventory.add_item(claw)
	entity_data.equip_item(claw, simple_blueprint.slots[0])
	
	entity_data.health_changed.connect(_on_health_changed)
	entity_data.died.connect(_on_died)
	_update_health_bar()

func _physics_process(delta):
	if not target or not is_instance_valid(target):
		return
	
	var distance_to_target = global_position.distance_to(target.global_position)
	
	# Try to attack if in range
	var weapons = entity_data.get_equipped_weapons()
	if weapons.size() > 0 and distance_to_target <= weapons[0].attack_range:
		attack(target)
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	# Update pathfinding periodically
	var current_time = Time.get_ticks_msec() / 1000.0
	if current_time - last_pathfind_time > pathfind_interval:
		path = _simple_pathfind(global_position, target.global_position)
		path_index = 0
		last_pathfind_time = current_time
	
	# Move along path
	if path.size() > 0 and path_index < path.size():
		var next_point = path[path_index]
		var direction = (next_point - global_position).normalized()
		var distance = global_position.distance_to(next_point)
		
		if distance < 10.0:
			path_index += 1
		else:
			velocity = direction * entity_data.get_speed_with_modifiers()
			move_and_slide()

func _simple_pathfind(from: Vector2, to: Vector2) -> Array[Vector2]:
	# Simple direct path for now - can be replaced with A* later
	return [to]

func set_target(new_target: EntityNode):
	target = new_target
