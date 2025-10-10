extends CharacterBody3D

@export var speed = 5.0

func _process(delta: float) -> void:
	# Get translation and rotation
	var translation = Input.get_axis("p_forward", "p_backward")
	var rotation = Input.get_axis("p_right", "p_left")
	
	# Rotate around the y axis
	rotate_y(rotation*delta*(PI/2))
	
	# Set up velocity
	velocity = transform.basis.z * translation * speed
	
	# MOVE
	move_and_slide()
