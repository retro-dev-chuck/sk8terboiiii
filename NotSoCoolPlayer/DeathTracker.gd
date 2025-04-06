class_name DeathTracker extends Node3D

@export var fatal_drop_distance: float = 8.0
@export var player: PlayerMovement
@export var respawn: Respawn
@onready var fader: FullScUi = %FullScUi


func _ready() -> void:
	player.on_death_trigger.connect(die)
	Events.on_screen_covered.connect(respawn_if_dead)

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
	fader.show_msg("You've died!")

func respawn_if_dead() -> void:
	if not player.has_died:
		return
	if Events.slot == null:
		Events.on_game_over.emit(0)
	else:
		player.last_ground_height = player.global_position.y
		respawn.spawn()
	
