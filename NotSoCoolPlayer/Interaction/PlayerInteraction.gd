class_name PlayerInteraction extends ShapeCast3D

signal on_interaction_successful(type: Enums.ItemType, interactable: Interactable)

@export var hand_slot_handler: HandSlotHandler
@export var side: Enums.Hand = Enums.Hand.None
var action: String = "SELECT_ACTION"

func _ready() -> void:
	if side == Enums.Hand.Left:
		action = "Interact_Left"
	elif side == Enums.Hand.Right:
		action = "Interact_Right"
		

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed(action):
		if not hand_slot_handler.is_side_full(side):
			_try_pick_item()
		else:
			_try_throw_item()
			
func _try_pick_item() -> void:
	if get_collision_count() == 0:
		return
	var interactable: Interactable = get_collider(0) as Interactable
	if interactable:
		var type: Enums.ItemType = interactable.interact()
		on_interaction_successful.emit(type, interactable)
				
func _try_throw_item() -> void:
	hand_slot_handler.throw_item(side)
