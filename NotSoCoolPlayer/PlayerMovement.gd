class_name PlayerMovement extends CharacterBody3D

@export var max_rotation_y: float = 75

@export var speed: float = 5.0
@export var sprint_speed: float = 8.0
@export var jump_velocity: float = 4.5

@export var pivot: Node3D
@export var sensitivity: float = 0.5

var input_dir: Vector2 = Vector2.ZERO

@export var coyote_time_length_ms: float = 300.0
var has_jump: bool = false
var was_grounded: bool = false
var ground_leave_time_start: float
var last_ground_height: float 

var has_died: bool = false

func _ready() -> void:
	last_ground_height = global_position.y
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if has_died:
		return
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sensitivity))
		pivot.rotate_x(deg_to_rad(-event.relative.y * sensitivity))
		pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-max_rotation_y), deg_to_rad(max_rotation_y))

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()
		
	if has_died:
		return
		
	if is_on_floor():
		last_ground_height = global_position.y
		
	if not has_jump and is_on_floor():
		has_jump = true
		
	if has_jump and Input.is_action_just_pressed("Jump") and _is_valid_time_to_jump():
		velocity.y = jump_velocity
		has_jump = false
	else:
		ground_leave_time_start = Time.get_ticks_msec()
		velocity += get_gravity() * delta

	input_dir = Input.get_vector("Left", "Right", "Up", "Down")
	
	_handle_ground_movement()
	was_grounded = is_on_floor()
	move_and_slide()

func _is_valid_time_to_jump() -> bool:
	var current_time: float = Time.get_ticks_msec()
	var time_passed_since_last_grounded: float = current_time - ground_leave_time_start
	return time_passed_since_last_grounded <= coyote_time_length_ms

func _handle_ground_movement() -> void:
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
