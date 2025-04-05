class_name PlayerTorch extends Node3D

signal on_expire()

@export var fresh_lifetime: float = 20.0
var lifetime: float = 20.0
var is_live: bool = false

func _ready() -> void:
	lifetime = 0
	is_live = false
	
func _process(delta: float) -> void:
	if not is_live:
		return
	lifetime -= delta
	if lifetime <= 0:
		_extinguish()
		
func _extinguish() -> void:
	is_live = false
	##todo: play vfx, sfx here
	## create empty throw on ground
	on_expire.emit()
	visible = false

func refresh() -> void:
	lifetime = fresh_lifetime
	is_live = true
	visible = true
