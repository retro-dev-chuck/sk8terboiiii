class_name Interactable extends Area3D

@export var type: Enums.ItemType = Enums.ItemType.None

func interact() -> Enums.ItemType:
	return type
