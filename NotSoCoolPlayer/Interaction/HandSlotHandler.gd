class_name HandSlotHandler extends Node3D

@export var item_throw: ItemThrow
@export var interaction_right: PlayerInteraction
@export var interaction_left: PlayerInteraction
@export var torch_right: PlayerTorch
@export var torch_left: PlayerTorch

var is_left_full: bool = false
var is_right_full: bool = false
 
func _ready() -> void:
	interaction_right.on_interaction_successful.connect(_handle_right_interaction)
	interaction_left.on_interaction_successful.connect(_handle_left_interaction)
	torch_left.on_expire.connect(_on_left_torch_expired)
	torch_right.on_expire.connect(_on_right_torch_expired)
	
func _handle_right_interaction(type: Enums.ItemType, interactable: Interactable) -> void:
	if type == Enums.ItemType.Torch:
		if torch_right.is_live:
			##should not end here, instead should throw torch
			return
		torch_right.refresh()
		interactable.picked_up()
		is_right_full = true
	
func _handle_left_interaction(type: Enums.ItemType, interactable: Interactable) -> void:
	if type == Enums.ItemType.Torch:
		if torch_left.is_live:
			##should not end here, instead should throw torch
			return
		torch_left.refresh()
		interactable.picked_up()
		is_left_full = true

func is_side_full(side: Enums.Hand) -> bool:
	if side == Enums.Hand.Left:
		return is_left_full
	if side == Enums.Hand.Right:
		return is_right_full
	push_warning("Hand None?????")
	return false

func _on_left_torch_expired() -> void:
	is_left_full = false
	
func _on_right_torch_expired() -> void:
	is_right_full = false

func throw_item(side: Enums.Hand) -> void:
	if side == Enums.Hand.Left:
		is_left_full = false
		torch_left._extinguish()
		item_throw.throw_torch(torch_left.global_position)
		
	if side == Enums.Hand.Right:
		is_right_full = false
		torch_right._extinguish()
		item_throw.throw_torch(torch_right.global_position)
