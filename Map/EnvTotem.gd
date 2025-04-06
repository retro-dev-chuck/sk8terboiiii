class_name EnvTotem extends Node3D

@export var interactable: Interactable

func _ready() -> void:
	interactable.on_picked_up.connect(_picked_up)
	
func _picked_up() -> void:
	Events.on_totem_picked_up.emit()
