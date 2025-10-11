extends CharacterBody3D

@export var speed:float = 5.0 # Movement speed
@export var possesed:Node3D # Target that is possesed
var possessor:ShapeCast3D # Detector for possession area
var mesh:MeshInstance3D # Player's mesh

const mouse_sens = 0.1 # Mouse sensative speed

var direction = Vector3.ZERO # Vector3 to determine direction of the characterBody3D
var lerp_speed = 10.0 # Speed of the lerp

func _ready() -> void:
	possessor = get_node("PossessionArea")
	mesh = get_node("MeshInstance3D")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # Locks mouse in window

func _input(event: InputEvent) -> void:
	# For each Input it checks if it was a mouse movement. If yes..
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sens)) # rotate cam along its Y (left to right)

func _physics_process(delta: float) -> void:
	
	#if not is_on_floor():
		#velocity += get_gravity() * delta
	
	# Get translation and rotation
	var input_dir = Input.get_vector("p_left", "p_right", "p_forward", "p_backward") # copy of default move
	# direction of the char based on mouse movement
	direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),delta*lerp_speed)

	# Set up velocity
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	# MOVE
	move_and_slide()
	
	if(Input.is_action_just_pressed("p_interact")):
		if(possesed == null):
			posses()
		elif(possesed != null):
			unposses()
			

func posses() -> void:
	# If the player is already possesing someone, return
	if(possesed != null):
		return
	
	# Get closest NPC to player
	possessor.force_shapecast_update()
	if(!possessor.is_colliding()):
		return
	var found = possessor.get_collider(0)
	if(found == null): # If there was no NPC, return
		return
	possesed = found as NPC
	
	# Make the player's NPC mesh visible
	if(possesed.type == 1):
		get_node("NPC1").show()
	elif(possesed.type == 2):
		get_node("NPC2").show()
	elif(possesed.type == 3):
		get_node("NPC3").show()
	else:
		return
	# Make the NPC invisible
	possesed.hide()
	# Make the player's ghost mesh invisible
	get_node("Ghost").hide()
	
	# Set collision masks
	for i in range(1,7):
		self.set_collision_mask_value(i,1)

# Unposses an NPC
func unposses() -> void:
	# If the player is not possesing anyone, return
	if(possesed == null):
		return
	
	# Set collision masks
	for i in range(1,7):
		self.set_collision_mask_value(i,0)
	
	# Teleport possesed object to player and make visible
	possesed.position = self.position
	possesed.show()
	possesed.rotation.x += 90
	
	# Move player to spot near possesed
	self.position.z += 2
	
	# Make the player's ghost mesh visible
	get_node("Ghost").show()
	if(possesed.type == 1):
		get_node("NPC1").hide()
	elif(possesed.type == 2):
		get_node("NPC2").hide()
	elif(possesed.type == 3):
		get_node("NPC3").hide()
	else:
		return
	
	# Player no longer references possesed object
	possesed = null
