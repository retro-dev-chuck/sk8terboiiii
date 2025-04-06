class_name PlayerTorch extends Node3D

signal on_expire()

const FRESH_LIFETIME: float = 20.0

@export var lifetime: Lifetime
@export var pfx: GPUParticles3D
@export var light: Node3D
@export var audio_player: AudioStreamPlayer3D
@export var audio_player_extinguish: AudioStreamPlayer3D

var is_live: bool = false

func _ready() -> void:
	lifetime.on_timer_finished.connect(_extinguish)
		
func _extinguish() -> void:
	on_expire.emit()
	pfx.visible = false
	light.visible = false
	is_live = false
	audio_player.stop()
	
func _hide() -> void:
	##todo: play vfx, sfx here
	## create empty throw on ground
	on_expire.emit()
	audio_player.stop()
	if audio_player_extinguish:
		audio_player_extinguish.stop()
	is_live = false
	visible = false

func refresh(time: float = FRESH_LIFETIME) -> void:
	if not audio_player.playing:
		audio_player.play()
	if audio_player_extinguish.playing:
		audio_player_extinguish.stop()
	pfx.amount = 16
	lifetime.start(time)
	is_live = true
	pfx.visible = true
	light.visible = true
	visible = true

func time_left() -> float:
	if lifetime:
		return lifetime.timer.wait_time	
	return 0
