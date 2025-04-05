class_name TorchHandler extends Node3D

@export var interaction_right: PlayerInteraction
@export var interaction_left: PlayerInteraction
@export var torch_right: PlayerTorch
@export var torch_left: PlayerTorch

func _ready() -> void:
	interaction_right.on_interaction_successful.connect(_handle_right_torch)
	interaction_left.on_interaction_successful.connect(_handle_left_torch)
	
	
func _handle_right_torch(type: Enums.ItemType, interactable: Interactable) -> void:
	if type == Enums.ItemType.Torch:
		if torch_right.is_live:
			##should not end here, instead should throw torch
			return
		torch_right.refresh()
		interactable.picked_up()
	
func _handle_left_torch(type: Enums.ItemType, interactable: Interactable) -> void:
	if type == Enums.ItemType.Torch:
		if torch_left.is_live:
			##should not end here, instead should throw torch
			return
		torch_left.refresh()
		interactable.picked_up()
