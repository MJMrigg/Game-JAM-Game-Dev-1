extends CharacterBody3D

class_name NPC

signal body_discovered(human)
signal points
@export var speed = 3
@export var type:int # Type of NPC it is
@export var navigator:NavigationAgent3D # Navigation agent
@export var rayCast:RayCast3D
@export var shapeCast:ShapeCast3D
@export var model:CharacterBody3D # The NPC's model for animation purposes
var unconcious = false # If the NPC is unconcious
var earshot:bool # If NPC is within earshot of player noise
var deadBodySight:bool = false# test bool to see if line of sight is working
var ghost:CharacterBody3D #Player
var start:Vector3 # Starting coordinates of NPC
var staring:bool = false # If curious sees body
@export var my_house:door # NPC's house

var animations:AnimationPlayer
var direction = Vector3.ZERO

@export var debugRay:RayCast3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ghost = get_tree().get_nodes_in_group("player")[0]
	start = position
	pick_new_target()
	animations = get_node("Person1/AnimationPlayer")

func _physics_process(delta: float) -> void:
	#print(self, ":", self.position)
	#print(staring, deadBodySight)
	# If the NPC is unconcious, do nothing
	if(unconcious):
		if(!deadBodySight):
			for human in shapeCast.get_collision_count():
				if(shapeCast.get_collider(human).is_in_group("NPCs")):
					#print("Found human in area")
					rayCast.target_position = rayCast.to_local(shapeCast.get_collision_point(human))
					rayCast.force_raycast_update()
					#print(shapeCast.get_collider(human).position)
					#print("Raycast Target: ", rayCast.target_position)
					#print(shapeCast.get_collider(human))
					#print(rayCast.get_collider())
					#print(rayCast.is_colliding())
					if(rayCast.is_colliding() && rayCast.get_collider() == shapeCast.get_collider(human)):
						print("Human can see me!")
						points.connect(get_node("../HUD_score").updateScore.bind())
						emit_signal("points")
						deadBodySight = true
						emit_signal("body_discovered", shapeCast.get_collider(human))
		return
	
	#Does nothing if it is looking at body
	if(staring):
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
		elif(type == 3):
			scared()
		
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
	
	
	animations.play("Walk_001")
	var look_target = Vector3(nextPos.x, model.global_position.y, nextPos.z)
	#var target_dir = (look_target - model.global_position).normalized()
	#var current_dir = model.transform.basis.z.normalized() #*-1
	#var new_dir = current_dir.slerp(target_dir, delta * 0.5) 
	#print(new_dir)
	#print(model.global_position)
	#print(model.global_position + new_dir)
	model.look_at(look_target, Vector3.UP)
	model.rotate(basis.y, 90.0)
	debugRay.target_position = debugRay.to_local(look_target)
	debugRay.force_raycast_update()
	
	# MOOOOOOOOOOOOOOOOOOVVEEEEEEE
	move_and_slide()

func pick_new_target() -> void:
	# Randomly generate a new target
	var randx:float = randf()*50 - 25
	var randz:float = randf()*50 - 25
	var new_target = Vector3(randx, position.y, randz)
	navigator.target_position = new_target

func scared() -> void:
	if(navigator.target_position == start):
		pick_new_target()
	else:
		navigator.target_position = start

func _on_body_discovered(human: Variant) -> void:
	if(type == 1):
		human.staring = true;
	elif(type == 3):
		human.scared()
