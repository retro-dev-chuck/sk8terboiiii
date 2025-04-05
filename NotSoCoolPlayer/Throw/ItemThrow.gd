class_name ItemThrow extends Node3D

@export var player: Node3D

@export var throw_force: float
@export var throw_angle: float
@export var sc_torch: PackedScene

func throw_torch(spawn_pos: Vector3) -> void:
	var new_torch: RigidBody3D = sc_torch.instantiate()
	get_tree().root.get_node("Game").add_child(new_torch)
	new_torch.global_position = spawn_pos
	new_torch.apply_central_impulse(-player.basis.z.normalized() * throw_force)
