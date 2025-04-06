class_name PlayerInteraction extends ShapeCast3D

signal on_interaction_successful(interactable: Interactable)

@export var hand_slot_handler: HandSlotHandler
@export var side: Enums.Hand = Enums.Hand.None
var action: String = "SELECT_ACTION"

func _ready() -> void:
	if side == Enums.Hand.Left:
		action = "Interact_Left"
	elif side == Enums.Hand.Right:
		action = "Interact_Right"
		
		
		
## CASES
## Totem: if totem slot place, else drop on the ground -> if you die you die 

func _input(_event: InputEvent) -> void:
	if State.is_story_playing:
		return
	if Input.is_action_just_pressed(action):
		## Campfire -> if holding torch refresh
		if get_collision_count() > 0:
			var interactable: Interactable = get_collider(0) as Interactable
			if interactable:
				var type: Enums.ItemType = interactable.interact()
				if type == Enums.ItemType.Campfire:
					on_interaction_successful.emit(interactable)
				elif type == Enums.ItemType.Torch: ## if pickable item
					##if side not full pick
					if hand_slot_handler.is_side_empty(side):
						on_interaction_successful.emit(interactable)
					##else throw
					else:
						_try_throw_item()
				elif type == Enums.ItemType.TotemSlot:
					var slot: TotemSlot = interactable.free_parent as TotemSlot
					if slot:
						if slot.has_totem:
							if hand_slot_handler.is_side_empty(side):
								on_interaction_successful.emit(interactable)
							else:##hand full can't take totem
								pass
						else: ##slot doesn't have totem
							if hand_slot_handler.is_side_empty(side):
								pass ##hand empty so do nothing
							else:
								on_interaction_successful.emit(interactable)
				elif type == Enums.ItemType.ResurrectionTotem:
					_try_throw_item()				
		else: ##No interactable object -> if hand full throw item
			_try_throw_item()	
					
func _try_throw_item() -> void:
	hand_slot_handler.throw_item(side)
