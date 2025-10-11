extends CharacterBody3D

@export var speed:float = 5.0 # Movement speed
@export var mouse_sens:float = 0.1 # Mouse sensative speed
@export var possesed:Node3D # Target that is possesed
var possessor:ShapeCast3D # Detector for possession area
var collider:CollisionShape3D # Collision detector
var sound_area:Area3D # Sound Area
var interactor:ShapeCast3D # Detector for objects to interact with
var knife:bool = false # If the player has the knife
signal wrong_door
signal menu
@export var target:NPC # The target

func _ready() -> void:
	possessor = get_node("PossessionArea")
	collider = get_node("CollisionShape3D")
	sound_area = get_node("SoundArea3D")
	interactor = get_node("Interactor")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # Locks mouse in window

# Player key input
func _unhandled_input(event: InputEvent) -> void:
	if(event.is_action_pressed("p_menu")):
		menu.emit()

# Have mouse rotate camera
func _input(event: InputEvent) -> void:
	# For each Input it checks if it was a mouse movement. If yes..
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sens)) # rotate cam along its Y (left to right)

func _process(delta: float) -> void:
	# Get translation and rotation
	var forward = Input.get_axis("p_forward", "p_backward")
	var right = Input.get_axis("p_right", "p_left")
	
	# Set up velocity
	velocity = (transform.basis.z * forward * speed) + (transform.basis.x * right * speed * -1)
	
	# MOVE
	move_and_slide()
	
	# If the player tries to posses someone
	if(Input.is_action_just_pressed("p_posses")):
		if(possesed == null):
			posses()
		elif(possesed != null):
			unposses()
	# If the player tries to interact with an object while possesing someone
	if(Input.is_action_just_pressed("p_interact") && possesed != null):
		interact()
	
	'''
	# Alternet sound check - David T
	if(Input.is_action_just_pressed("p_sound")):
		var area = sound_area.get_overlapping_bodies()
		for human in area:
			if(human.is_in_group("NPCs")):
				human.earshot = true
	'''

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
	#possesed.rotation.x = 90
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
	#return
	if(body.is_in_group("NPCs")):
		body.earshot = true
	
func earshot_exited(body: Node3D) -> void:
	#return
	if(body.is_in_group("NPCs")):
		body.earshot = false

# Interact with an object
func interact():
	# If the player isn't possesing anyone, do nothing
	if(possesed == null):
		return
	
	# Get closest object for the player to interact with
	var found = interactor.get_collider(0)
	if(found == null):
		return
	elif(found is door):
		# If it was the correct door, open it. Else, tell the player it's the wrong door
		if(possesed.my_door == found):
			found.queue_free()
		else:
			wrong_door.emit()
	elif(found is knife): # If it's the knife, make the knife show on all the models
		found.queue_free()
		get_node("NPC1/blade").show()
		knife = true # The player now has the knife
