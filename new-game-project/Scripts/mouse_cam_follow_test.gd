extends CharacterBody3D

@onready var head: Node3D = $"don't_ask_why/Head"

@export var speed:float = 5.0 # Movement speed
@export var possesed:Node3D # Target that is possesed
var possessor:ShapeCast3D # Detector for possession area
var mesh:MeshInstance3D # Player's mesh

const mouse_sens = 0.1

var direction = Vector3.ZERO
var lerp_speed = 10.0

func _ready() -> void:
	#possessor = get_node("PossessionArea")
	#mesh = get_node("MeshInstance3D")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-30), deg_to_rad(30))

func _physics_process(delta: float) -> void:
	
	#if not is_on_floor():
		#velocity += get_gravity() * delta
	
	# Get translation and rotation
	#var input_dir = Input.get_vector("p_left", "p_right", "p_forward", "p_backward")
	var input_dir = Input.get_vector("p_backward", "p_forward", "p_left", "p_right",)
	direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),delta*lerp_speed)

	# Set up velocity
	#velocity = transform.basis.z * translation * speed
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	# MOVE
	move_and_slide()
