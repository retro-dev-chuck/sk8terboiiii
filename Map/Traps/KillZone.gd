class_name KillZone extends Area3D

func activate() -> void:
	var bodies: Array[Node3D] =  get_overlapping_bodies()
	for body in bodies:
		var player: PlayerMovement = body as PlayerMovement
		if player:
			player.trap_death()
			return
