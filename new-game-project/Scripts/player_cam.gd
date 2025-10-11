extends Camera3D

@export var target: Node3D # Target to follow
# Distances the camera will follow the target
@export var x_distance: float
@export var y_distance: float
@export var z_distance: float

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Make sure target exists with valid follow distances
	if(target == null || x_distance == null || y_distance == null || z_distance == null):
		return
	# Set position at each distance from the target and look at the target
	position = target.position + target.basis.z*z_distance + target.basis.y*y_distance + target.basis.x*x_distance
	look_at(target.position)

func _unhandled_input(event: InputEvent) -> void:
	if(event.is_action_pressed("p_perspective") && z_distance != null):
		z_distance *= -1
		
	if(event.is_action_pressed("p_zoom_in")):
		z_distance = clamp(z_distance, 0.5, 3) - 0.25
		
	if(event.is_action_pressed("p_zoom_out")):
		z_distance = clamp(z_distance, 0.5, 3) + 0.25
