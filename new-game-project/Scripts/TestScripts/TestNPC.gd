extends CharacterBody3D

@export var speed = 4
@export var navigator:NavigationAgent3D # Navigation agent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	navigator.target_position = Vector3(5,position.y,5)

func _physics_process(delta: float) -> void:
	# Set up velocity
	velocity = Vector3.ZERO
	# If there is no navigator, do nothing
	if(navigator == null):
		print("Error: No Selected Navigation Agent")
		return
	# Check if the target position has been reached
	print(!navigator.is_navigation_finished() and navigator.is_target_reachable())
	if(!navigator.is_navigation_finished() and navigator.is_target_reachable()):
		# If it has, continue on the path
		var desired_direction = Vector3(navigator.get_next_path_position() - global_position).normalized()
		velocity = desired_direction * speed
	elif(navigator.is_navigation_finished()):
		# If it has, calculate a new position
		#pick_new_target()
		pass
	else:
		print("Navigator Error")
	
	# MOOOOOOOOOOOOOOOOOOVVEEEEEEE
	move_and_slide()

func pick_new_target() -> void:
	while(1):
		# Randomly generate a new target
		var randx:float = randf()*100 - 50
		var randz:float = randf()*100 - 50
		var new_target = Vector3(randx, position.y, randz)
		navigator.target_position = new_target
		# If it is reachable, return
		if(navigator.is_target_reachable()):
			break
		# If it's not, keep generating a new target
