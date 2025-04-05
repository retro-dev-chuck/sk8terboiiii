class_name CoolPlayer extends CharacterBody3D

@export var max_rotation_y: float = 75

@export var speed: float = 5.0
@export var minimum_speed: float = 1
@export var jump_velocity: float = 4.5

@export var pivot: Node3D
@export var sensitivity: float = 0.5

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

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_velocity

	var input_dir := Input.get_vector("Left", "Right", "Up", "Down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
