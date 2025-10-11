extends CharacterBody3D

class_name NPC

@export var speed = 3
@export var type:int # Type of NPC it is
@export var navigator:NavigationAgent3D # Navigation agent
@export var deadArea:Area3D # Observable Dead Area
@export var rayCast:RayCast3D
@export var shapeCast:ShapeCast3D
var unconcious = false # If the NPC is unconcious
var earshot:bool # If NPC is within earshot of player noise
var deadBodySight:bool # test bool to see if line of sight is working
var ghost:CharacterBody3D #Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ghost = get_tree().get_nodes_in_group("player")[0]
	pick_new_target()

func _physics_process(delta: float) -> void:
	print(self, ":", self.position)
	
	# If the NPC is unconcious, do nothing
	if(deadBodySight):
		print("SCREAM! A dead body.")
		
	if(unconcious):
		deadBodySight = false
		#var area = deadArea.get_overlapping_bodies() 
		for human in shapeCast.get_collision_count():
			if(shapeCast.get_collider(human).is_in_group("NPCs")):
				#print("Found human in area")
				rayCast.target_position = rayCast.to_local(shapeCast.get_collision_point(human))
				rayCast.force_raycast_update()
				#print(shapeCast.get_collider(human).position)
				print("Raycast Target: ", rayCast.target_position)
				#print(shapeCast.get_collider(human))
				#print(rayCast.get_collider())
				#print(rayCast.is_colliding())
				if(rayCast.is_colliding() && rayCast.get_collider() == shapeCast.get_collider(human)):
					print("Human can see me!")
					shapeCast.get_collider(human).deadBodySight = true
		
		'''
		for human in area:
			if(human.is_in_group("NPCs")):
				print("Found human in area")
				rayCast.target_position = to_local(human.global_position)
				rayCast.force_raycast_update()
				if(rayCast.is_colliding() && rayCast.get_collider() == human):
					human.deadBodySight = true
		'''
		return
	
	# Check if nav map exists
	if(NavigationServer3D.map_get_iteration_id(navigator.get_navigation_map()) == 0):
		print("Error: No Navigation Mesh")
		return
	# If there is no navigator, do nothing
	if(navigator == null):
		print("Error: No Selected Navigation Agent")
		return
	
	# Reacts if close enough to sound
	if(Input.is_action_just_pressed("p_sound") && earshot):
		if(type == 1):
			navigator.target_position = ghost.position
		
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
