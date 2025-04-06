class_name StoryTrigger extends Area3D

var story_canvas_layer: StoryUi

@export var msg: Array[String]

func _ready() -> void:
	body_entered.connect(_show_messages)
	story_canvas_layer = get_tree().root.get_node("Game").get_node("%Story_CanvasLayer")


func _show_messages(body: Node3D) -> void:
	story_canvas_layer.show_messages(msg)
