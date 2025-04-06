class_name HandSlotHandler extends Node3D

@export var item_throw: ItemThrow
@export var interaction_right: PlayerInteraction
@export var interaction_left: PlayerInteraction
@export var torch_right: PlayerTorch
@export var torch_left: PlayerTorch

var left_hand_item: Enums.ItemType = Enums.ItemType.None
var right_hand_item: Enums.ItemType = Enums.ItemType.None
 
func _ready() -> void:
	interaction_right.on_interaction_successful.connect(_handle_right_interaction)
	interaction_left.on_interaction_successful.connect(_handle_left_interaction)
	
func _handle_right_interaction(interactable: Interactable) -> void:
	var type: Enums.ItemType = interactable.type
	if type == Enums.ItemType.Torch:
		if torch_right.is_live:
			##should not end here, instead should throw torch
			return
		torch_right.refresh(interactable.get_lifetime())
		interactable.picked_up()
		right_hand_item = Enums.ItemType.Torch
	elif type == Enums.ItemType.Campfire:
		if right_hand_item == Enums.ItemType.Torch:
			torch_right.refresh()
	elif type == Enums.ItemType.ResurrectionTotem:
		print("r")
	
func _handle_left_interaction(interactable: Interactable) -> void:
	var type: Enums.ItemType = interactable.type
	if type == Enums.ItemType.Torch:
		if torch_left.is_live:
			##should not end here, instead should throw torch
			return
		torch_left.refresh(interactable.get_lifetime())
		interactable.picked_up()
		left_hand_item = Enums.ItemType.Torch
	elif type == Enums.ItemType.Campfire:
		if left_hand_item == Enums.ItemType.Torch:
			torch_left.refresh()
	elif type == Enums.ItemType.ResurrectionTotem:
		print("l")

func is_side_empty(side: Enums.Hand) -> bool:
	if side == Enums.Hand.Left:
		push_warning("Left hand used", left_hand_item == Enums.ItemType.None)
		return left_hand_item == Enums.ItemType.None
	if side == Enums.Hand.Right:
		push_warning("Right hand used", left_hand_item == Enums.ItemType.None)
		return right_hand_item == Enums.ItemType.None
	push_warning("None hand used?", side)
	return false

func throw_item(side: Enums.Hand) -> void:
	if side == Enums.Hand.Left and left_hand_item == Enums.ItemType.Torch:
		left_hand_item = Enums.ItemType.None
		torch_left._hide()
		item_throw.throw_torch(torch_left.global_position, torch_left.time_left())
	elif side == Enums.Hand.Right and right_hand_item == Enums.ItemType.Torch:
		right_hand_item = Enums.ItemType.None
		torch_left._hide()
		item_throw.throw_torch(torch_right.global_position, torch_left.time_left())
