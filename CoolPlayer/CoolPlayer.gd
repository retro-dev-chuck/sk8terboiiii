class_name CoolPlayer extends CharacterBody3D

@export var max_rotation_y: float = 75

@export var speed: float = 5.0
@export var slide_steer_speed: float = 1
@export var jump_velocity: float = 4.5

@export var pivot: Node3D
@export var groundcast: ShapeCast3D
@export var sensitivity: float = 0.5

var isSurfing: bool = false
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
	
	_handle_slide(delta, velocity)
	_handle_ground_movement(delta, velocity)

	move_and_slide()

func _handle_slide(delta: float, vel: Vector3) -> void:
	if(is_on_wall_only() and get_slide_collision_count() > 0 and groundcast.get_collider(0)):
		var col: KinematicCollision3D = get_slide_collision(0)
		var col_angle: float = rad_to_deg(col.get_angle())
		isSurfing = col_angle < 90 - wall_min_slide_angle and col_angle > floor_max_angle
	else:
		isSurfing = false
		
	if isSurfing:
		direction = (transform.basis * Vector3(0, 0, input_dir.y)).normalized()
		var old_length: float = velocity.length()
		for i in range(get_slide_collision_count()):
			var col = get_slide_collision(i)
			velocity = velocity.slide(col.get_normal())
		if velocity.length() < old_length:
			velocity = velocity.normalized() * old_length
		var steer_force: float = 5.0
		if direction != Vector3.ZERO:
			velocity += direction.normalized() * steer_force * delta
		
	if Input.is_action_just_pressed("Jump"):
		var horizontal_vel: Vector3 = velocity
		horizontal_vel.y = 0.0
		velocity = horizontal_vel
		velocity.y = jump_velocity

func _handle_ground_movement(delta: float, vel: Vector3) -> void:
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_velocity
	if isSurfing:
		return
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var ground_acceleration: float = 10.0
	if direction != Vector3.ZERO:
		var target_velocity: Vector3 = direction * speed
		velocity.x = move_toward(velocity.x, target_velocity.x, ground_acceleration * delta)
		velocity.z = move_toward(velocity.z, target_velocity.z, ground_acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, ground_acceleration * delta)
		velocity.z = move_toward(velocity.z, 0, ground_acceleration * delta)
