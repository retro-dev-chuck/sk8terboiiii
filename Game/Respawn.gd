class_name Respawn extends Node3D

@export var player: PlayerMovement

func spawn() -> void:
	if not player.has_died:
		return
	player.global_position = Events.slot.global_position
	player.global_basis = Events.slot.global_basis
	player.has_died = false
