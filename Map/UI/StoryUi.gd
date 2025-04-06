class_name StoryUi extends CanvasLayer

@export var bottom_label: Label
@export var bottom_container: MarginContainer
@export var bottom_anim: AnimationPlayer
@export var base_char_count: float = 75

var messages_to_display: Array[String] = []

func show_messages(messages: Array[String]) -> void:
	if not bottom_container.visible:
		bottom_label.visible_ratio = 0
		bottom_container.visible = true
	if not messages or messages.size() == 0:
		return
	State.is_story_playing = true
	messages_to_display = messages
	_show_next()
	
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Interact_Left") or \
	Input.is_action_just_pressed("Interact_Right"):
		if bottom_anim.is_playing():
			bottom_anim.seek(bottom_anim.current_animation.length(), true)
		else:
			_show_next()

func _show_next() -> void:
	if messages_to_display and messages_to_display.size() > 0:
		var speed_scale: float =  base_char_count /messages_to_display[0].length()
		bottom_label.visible_ratio = 0.0
		bottom_label.text = messages_to_display[0]
		messages_to_display.remove_at(0)
		bottom_anim.speed_scale = speed_scale
		bottom_anim.play("show")
	else:
		State.is_story_playing = false
		bottom_container.visible = false
		
