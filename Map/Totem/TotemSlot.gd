class_name TotemSlot extends Node3D

@export var spawn_point: Node3D
@export var has_totem: bool = false
@export var totem_visual: Node3D

func _ready() -> void:
	if has_totem:
		Events.slot = self
		Events.on_totem_placed.emit()
	totem_visual.visible = has_totem

func totem_placed() -> void:
	has_totem = true
	totem_visual.visible = true
	Events.slot = self
	Events.on_totem_placed.emit()

func totem_taken() -> void:
	has_totem = false
	totem_visual.visible = false
	Events.slot = null
	Events.on_totem_picked_up.emit()
