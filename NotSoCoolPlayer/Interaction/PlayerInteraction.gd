class_name PlayerInteraction extends ShapeCast3D

signal on_interaction_successful(interactable: Interactable)

@export var hand_slot_handler: HandSlotHandler
@export var side: Enums.Hand = Enums.Hand.None
var story_canvas_layer: StoryUi
var fullscui: FullScUi
var action: String = "SELECT_ACTION"

func _ready() -> void:
	if side == Enums.Hand.Left:
		action = "Interact_Left"
	elif side == Enums.Hand.Right:
		action = "Interact_Right"

func _input(_event: InputEvent) -> void:
	if Time.get_ticks_msec() - State.story_end_time < 0.3:
		print(Time.get_ticks_msec() - State.story_end_time)
		return
	if State.is_story_playing or State.is_player_dead:
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
							if slot.is_sticky:
								if not story_canvas_layer:
									story_canvas_layer = get_tree().root.get_node("Game").get_node("%Story_CanvasLayer")
									story_canvas_layer.show_messages(["It's stuck........."])
								##await sometime and Ending A
								return
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
				elif type == Enums.ItemType.Amberstone:	
					on_interaction_successful.emit(interactable)
					if Events.slot and (Events.slot.id == 2 or Events.slot.id == 3 or Events.slot.id == 4 or Events.slot.id == 5):
						if not fullscui:
							fullscui = get_tree().root.get_node("Game").get_node("%FullScUi")
							if fullscui:
								fullscui.show_msg("Congratulations?")
								Events.on_game_over.emit(1)
					elif not Events.slot:
						if not fullscui:
							fullscui = get_tree().root.get_node("Game").get_node("%FullScUi")
							if fullscui:
								fullscui.show_msg("Congratulations?")
								Events.on_game_over.emit(3)
		else: ##No interactable object -> if hand full throw item
			_try_throw_item()	
					
func _try_throw_item() -> void:
	hand_slot_handler.throw_item(side)
