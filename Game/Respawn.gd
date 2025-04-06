class_name Respawn extends Node3D

@export var player: PlayerMovement

func spawn() -> void:
	if not player.has_died:
		return
	player.global_position = Events.slot.spawn_point.global_position
	player.global_basis = Events.slot.spawn_point.global_basis
	player.has_died = false
	State.is_player_dead = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Restart"):
		get_tree().reload_current_scene()
