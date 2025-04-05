class_name Interactable extends Area3D

@export var type: Enums.ItemType = Enums.ItemType.None
@export var free_parent: Node3D

func interact() -> Enums.ItemType:
	return type

func picked_up() -> void:
	free_parent.free()
