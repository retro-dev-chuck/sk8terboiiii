class_name FullScUi extends CanvasLayer
@onready var fade_panel: Panel = $FadePanel
@onready var story_canvas_layer: StoryUi = %Story_CanvasLayer

@export var label: Label
@export var anim: AnimationPlayer
var go: bool = false

func _ready() -> void:
	Events.on_game_over.connect(_game_over)
	
func show_msg(msg:String) -> void:
	fade_panel.modulate.a = 0
	label.text = msg
	anim.play("fadein")
	await get_tree().create_timer(1).timeout
	Events.on_screen_covered.emit()
	await get_tree().create_timer(1.5).timeout
	if not go:
		anim.play("fadeout")
	
func _game_over(case: int) -> void:
	if go:
		return
	go = true
	match (case):
		0:##death game over
			story_canvas_layer.show_messages(["Ending A: Death takes another greedy soul...", "Press R to restart."])
		1: 
			story_canvas_layer.show_messages(["Ending B: You got The Amberstone!", "Dungeon will keep you alive forever.", "At least you're not alone...", "Press R to restart."])
		2:	
			story_canvas_layer.show_messages(["Ending C: You got The Amberstone!", "You are forever freed from the chains of labor!", "Thanks for playing!"])
		3:	
			story_canvas_layer.show_messages(["Ending D: You got The Amberstone!", "You notice that you can't climb back up...", "Only way out is death", "Press R to restart."])
