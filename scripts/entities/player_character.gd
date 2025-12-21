class_name PlayerCharacter
extends EntityNode

var move_target: Vector2 = Vector2.ZERO
var has_move_target: bool = false
var nearby_enemies: Array[EntityNode] = []

func _ready():
	super._ready()
	
	# Create player entity data
	var player_stats = Stats.new(100.0, 10.0, 150.0)
	var player_blueprint = Blueprint.create_basic_character()
	entity_data = Entity.new("Player", player_stats, player_blueprint)
	
	# Equip basic sword
	var sword = Weapon.create_basic_sword()
	entity_data.inventory.add_item(sword)
	var weapon_slots = player_blueprint.get_slots_of_type(GameEnums.ItemType.WEAPON_HANDHELD)
	if weapon_slots.size() > 0:
		entity_data.equip_item(sword, weapon_slots[0])
	
	entity_data.health_changed.connect(_on_health_changed)
	entity_data.died.connect(_on_died)
	_update_health_bar()

func _physics_process(delta):
	# Handle movement
	if has_move_target:
		var direction = (move_target - global_position).normalized()
		var distance = global_position.distance_to(move_target)
		
		if distance > 5.0:
			velocity = direction * entity_data.get_speed_with_modifiers()
			move_and_slide()
		else:
			has_move_target = false
			velocity = Vector2.ZERO
	
	# Auto-attack nearest enemy
	if nearby_enemies.size() > 0:
		# Clean up dead enemies
		nearby_enemies = nearby_enemies.filter(func(e): return is_instance_valid(e))
		
		if nearby_enemies.size() > 0:
			var nearest = nearby_enemies[0]
			attack(nearest)

func set_move_target(target: Vector2):
	move_target = target
	has_move_target = true

func _on_detection_area_body_entered(body):
	if body is EnemyCharacter:
		nearby_enemies.append(body)

func _on_detection_area_body_exited(body):
	if body is EnemyCharacter:
		nearby_enemies.erase(body)

func _on_died():
	# Player died - game over
	get_tree().call_deferred("reload_current_scene")
