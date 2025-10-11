extends CharacterBody3D

@export var speed:float = 5.0 # Movement speed
@export var possesed:Node3D # Target that is possesed
var possessor:ShapeCast3D # Detector for possession area
var collider:CollisionShape3D # Collision detector
var sound_area:Area3D # Sound Area

func _ready() -> void:
	possessor = get_node("PossessionArea")
	collider = get_node("CollisionShape3D")
	sound_area = get_node("SoundArea3D")

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
	
	# If the player tries to posses someone
	if(Input.is_action_just_pressed("p_interact")):
		if(possesed == null):
			posses()
		elif(possesed != null):
			unposses()

# Posses an NPC
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
	# If the NPC is unconcious, do not posses them
	if(possesed.unconcious):
		possesed = null
		return
	
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
	possesed.rotation.x = 90
	possesed.unconcious = true
	
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

func earshot_entered(body: Node3D) -> void:
	if(body.is_in_group("NPCs")):
		body.earshot = true
	
func earshot_exited(body: Node3D) -> void:
	if(body.is_in_group("NPCs")):
		body.earshot = false
