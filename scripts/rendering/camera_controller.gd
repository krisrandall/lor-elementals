class_name CameraController
extends Camera2D

# Zoom settings
@export var min_zoom: float = 0.5
@export var max_zoom: float = 3.0
@export var zoom_speed: float = 0.15
@export var mouse_wheel_zoom_speed: float = 0.1

# Pinch tracking
var target_zoom: Vector2 = Vector2.ONE
var touch_points: Dictionary = {}  # Index -> Position
var last_pinch_distance: float = 0.0
var is_pinching: bool = false

func _ready():
	zoom = Vector2.ONE
	target_zoom = zoom
	
	# Enable multi-touch
	get_viewport().set_input_as_handled()

func _unhandled_input(event):
	# Mouse wheel zoom (desktop testing)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			zoom_in()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			zoom_out()
	
	# Touch events - track all touch points
	if event is InputEventScreenTouch:
		if event.pressed:
			touch_points[event.index] = event.position
			print("Touch pressed: ", event.index, " at ", event.position)
		else:
			touch_points.erase(event.index)
			print("Touch released: ", event.index)
		
		# Reset pinch when touches change
		if touch_points.size() != 2:
			is_pinching = false
			last_pinch_distance = 0.0
	
	# Drag events - update touch positions
	if event is InputEventScreenDrag:
		touch_points[event.index] = event.position
		
		# Only handle pinch if we have exactly 2 touches
		if touch_points.size() == 2:
			if not is_pinching:
				is_pinching = true
				var positions = touch_points.values()
				last_pinch_distance = positions[0].distance_to(positions[1])
				print("Pinch started, distance: ", last_pinch_distance)
			else:
				handle_pinch_zoom()

func _process(delta):
	# Smooth zoom interpolation
	zoom = zoom.lerp(target_zoom, zoom_speed)

func handle_pinch_zoom():
	var positions = touch_points.values()
	if positions.size() != 2:
		return
	
	var current_distance = positions[0].distance_to(positions[1])
	
	if last_pinch_distance > 0:
		# Calculate zoom change based on distance ratio
		var distance_ratio = current_distance / last_pinch_distance
		
		# Apply zoom change
		var zoom_change = (distance_ratio - 1.0) * 1  # Sensitivity multiplier
		
		if distance_ratio > 1.0:
			# Pinching out - zoom in
			zoom_in(abs(zoom_change))
		else:
			# Pinching in - zoom out
			zoom_out(abs(zoom_change))
	
	last_pinch_distance = current_distance

func zoom_in(amount: float = mouse_wheel_zoom_speed):
	target_zoom += Vector2(amount, amount)
	target_zoom = target_zoom.clamp(Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))

func zoom_out(amount: float = mouse_wheel_zoom_speed):
	target_zoom -= Vector2(amount, amount)
	target_zoom = target_zoom.clamp(Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))
