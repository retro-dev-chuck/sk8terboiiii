class_name PlayerInteraction extends ShapeCast3D

signal on_interaction_successful(type: Enums.ItemType, interactable: Interactable)

@export var action: String = "SELECT_ACTION"

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed(action):
		if get_collision_count() == 0:
			return
		var interactable: Interactable = get_collider(0) as Interactable
		if interactable:
			var type: Enums.ItemType = interactable.interact()
			on_interaction_successful.emit(type, interactable)
