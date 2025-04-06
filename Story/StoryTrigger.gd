class_name StoryTrigger extends Area3D

var story_canvas_layer: StoryUi
@export var msg: Array[String]

func _ready() -> void:
	body_entered.connect(_show_messages)
	story_canvas_layer = get_tree().root.get_node("Game").get_node("%Story_CanvasLayer")

##show only once
func _show_messages(body: Node3D) -> void:
	body_entered.disconnect(_show_messages)
	story_canvas_layer.show_messages(msg)
