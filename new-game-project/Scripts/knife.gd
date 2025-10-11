extends CharacterBody3D

class_name knife

func _process(delta: float) -> void:
	# Have gravity take effect
	if(!is_on_floor()):
		velocity += get_gravity()
		move_and_slide()
