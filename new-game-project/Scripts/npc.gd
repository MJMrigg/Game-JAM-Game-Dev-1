extends CharacterBody3D

class_name NPC

@export var speed = 3
@export var type:int # Type of NPC it is
@export var navigator:NavigationAgent3D # Navigation agent
var unconcious = false # If the NPC is unconcious

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pick_new_target()

func _physics_process(delta: float) -> void:
	# If the NPC is unconcious, do nothing
	if(unconcious):
		return
	# Check if nav map exists
	if(NavigationServer3D.map_get_iteration_id(navigator.get_navigation_map()) == 0):
		print("Error: No Navigation Mesh")
		return
	# If there is no navigator, do nothing
	if(navigator == null):
		print("Error: No Selected Navigation Agent")
		return
	
	# Check if the target was reached or if it's not reachable
	if(navigator.is_target_reached() || !navigator.is_target_reachable()):
		pick_new_target()
		return
	
	# Set up velocity
	velocity = Vector3.ZERO
	var nextPos = navigator.get_next_path_position()
	var newVel = global_position.direction_to(nextPos) * speed
	if(navigator.avoidance_enabled):
		navigator.velocity = newVel
	else:
		velocity = newVel
	
	# MOOOOOOOOOOOOOOOOOOVVEEEEEEE
	move_and_slide()

func pick_new_target() -> void:
	# Randomly generate a new target
	var randx:float = randf()*50 - 25
	var randz:float = randf()*50 - 25
	var new_target = Vector3(randx, position.y, randz)
	navigator.target_position = new_target
