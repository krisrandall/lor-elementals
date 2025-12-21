class_name HomeCastle
extends EntityNode

func _ready():
	super._ready()
	
	# Create castle entity data
	var castle_stats = Stats.new(500.0, 0.0, 0.0)
	var castle_blueprint = Blueprint.new("Home Castle", GameEnums.EntityType.TOWER)
	entity_data = Entity.new("Home Castle", castle_stats, castle_blueprint)
	
	entity_data.health_changed.connect(_on_health_changed)
	entity_data.died.connect(_on_died)
	_update_health_bar()

func _on_died():
	# Castle destroyed - game over
	get_tree().call_deferred("reload_current_scene")
