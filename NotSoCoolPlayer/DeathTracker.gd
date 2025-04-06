class_name DeathTracker extends Node3D

@export var fatal_drop_distance: float = 8.0
@export var player: PlayerMovement
@export var respawn: Respawn

func _ready() -> void:
	player.on_death_trigger.connect(die)

func _physics_process(_delta: float) -> void:
	if not player.is_on_floor():
		var total_drop: float = abs(player.global_position.y - player.last_ground_height)
		if total_drop >= fatal_drop_distance:
			die()

func die() -> void:
	if player.has_died:
		return
	player.has_died = true
	State.is_player_dead = true
	await get_tree().create_timer(2).timeout
	if Events.slot == null:
		pass
		##GAME OVER
	else:
		respawn.spawn()
