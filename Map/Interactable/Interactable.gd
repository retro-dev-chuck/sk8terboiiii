class_name Interactable extends Area3D

signal on_picked_up()

@export var type: Enums.ItemType = Enums.ItemType.None
@export var free_parent: Node3D
@export var lifetime: Lifetime

func interact() -> Enums.ItemType:
	return type

func picked_up() -> void:
	on_picked_up.emit()
	free_parent.free()
	
func has_lifetime() -> bool:
	return lifetime != null
	
func get_lifetime() -> float:
	if has_lifetime():
		return lifetime.timer.wait_time
	else:
		match(type):
			Enums.ItemType.Torch:
				return PlayerTorch.FRESH_LIFETIME
		return 0
