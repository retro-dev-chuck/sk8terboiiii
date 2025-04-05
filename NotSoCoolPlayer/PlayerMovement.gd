class_name PlayerMovement extends CharacterBody3D

@export var max_rotation_y: float = 75

@export var speed: float = 5.0
@export var sprint_speed: float = 8.0
@export var jump_velocity: float = 4.5

@export var pivot: Node3D
@export var sensitivity: float = 0.5

var input_dir: Vector2 = Vector2.ZERO
var direction: Vector3 = Vector3.ZERO

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sensitivity))
		pivot.rotate_x(deg_to_rad(-event.relative.y * sensitivity))
		pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-max_rotation_y), deg_to_rad(max_rotation_y))

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	input_dir = Input.get_vector("Left", "Right", "Up", "Down")
	
	_handle_ground_movement(delta, velocity)

	move_and_slide()

func _handle_ground_movement(delta: float, vel: Vector3) -> void:
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_velocity
		
	var acceleration: float = speed
	if Input.is_action_pressed("Sprint"):
		acceleration = sprint_speed
		
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * acceleration
		velocity.z = direction.z * acceleration
	else:
		velocity.x = move_toward(velocity.x, 0, acceleration)
		velocity.z = move_toward(velocity.z, 0, acceleration)
