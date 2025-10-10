extends CharacterBody3D

@export var speed:float = 5.0 # Movement speed
@export var possesed:Node3D # Target that is possesed
var possessor:ShapeCast3D # Detector for possession area
var mesh:MeshInstance3D # Player's mesh

func _ready() -> void:
	possessor = get_node("PossessionArea")
	mesh = get_node("MeshInstance3D")

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
			print("TEST")
			posses()
	
	# If the player was possessing anyone, move them the player position
	if(possesed != null):
		possesed.position = self.position

func posses() -> void:
	# If the player is already possesing someone, return
	if(possesed != null):
		return
	
	# Get closest NPC to player
	possessor.force_shapecast_update()
	possesed = possessor.get_collider(0) # No checks needed, since possessor only looks for NPCs
		
	# Make the NPC invisible and the player's mesh the npc's mesh so that it looks like the player possessed them
	possesed.hide()
	mesh.mesh = possesed.
