class_name HandSlotHandler extends Node3D

@export var item_throw: ItemThrow
@export var interaction_right: PlayerInteraction
@export var interaction_left: PlayerInteraction
@export var torch_right: PlayerTorch
@export var torch_left: PlayerTorch
@export var totem_left: Node3D
@export var totem_right: Node3D

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
	elif type == Enums.ItemType.TotemSlot:
		var slot: TotemSlot = interactable.free_parent as TotemSlot
		if slot:
			_handle_totem_slot_right(slot)
	
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
	elif type == Enums.ItemType.TotemSlot:
		var slot: TotemSlot = interactable.free_parent as TotemSlot
		if slot:
			_handle_totem_slot_left(slot)

func _handle_totem_slot_left(slot: TotemSlot) -> void:
	if slot.has_totem:
		if is_side_empty(Enums.Hand.Left):
			slot.totem_taken()
			left_hand_item = Enums.ItemType.ResurrectionTotem
			totem_left.visible = true
			pass
		else:##hand full can't take totem
			pass
	else: ##slot doesn't have totem
		if is_side_empty(Enums.Hand.Left):
			pass
		else:##if has totem, place down totem
			if left_hand_item == Enums.ItemType.ResurrectionTotem:
				left_hand_item = Enums.ItemType.None
				slot.totem_placed()
				totem_left.visible = false
				
func _handle_totem_slot_right(slot: TotemSlot) -> void:
	if slot.has_totem:
		if is_side_empty(Enums.Hand.Right):
			right_hand_item = Enums.ItemType.ResurrectionTotem
			slot.totem_taken()
			totem_right.visible = true
			pass
		else:##hand full can't take totem
			pass
	else: ##slot doesn't have totem
		if is_side_empty(Enums.Hand.Right):
			pass
		else:##if has totem, place down totem
			if right_hand_item == Enums.ItemType.ResurrectionTotem:
				right_hand_item = Enums.ItemType.None
				slot.totem_placed()
				totem_right.visible = false		
						
func is_side_empty(side: Enums.Hand) -> bool:
	if side == Enums.Hand.Left:
		return left_hand_item == Enums.ItemType.None
	if side == Enums.Hand.Right:
		return right_hand_item == Enums.ItemType.None
	return false

func throw_item(side: Enums.Hand) -> void:
	if side == Enums.Hand.Left and left_hand_item == Enums.ItemType.Torch:
		left_hand_item = Enums.ItemType.None
		torch_left._hide()
		item_throw.throw_torch(torch_left.global_position, torch_left.time_left())
	elif side == Enums.Hand.Right and right_hand_item == Enums.ItemType.Torch:
		right_hand_item = Enums.ItemType.None
		torch_right._hide()
		item_throw.throw_torch(torch_right.global_position, torch_right.time_left())
