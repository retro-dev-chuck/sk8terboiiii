class_name Story extends Node

@export var ui: StoryUi

var intro: Array[String] =\
["You came here to get the amberstone from the bottom of the dungeon...",\
"Many have failed, but you came prepared.",\
"You gave all your money to a Dahlian merchant and got the resurrection totem",\
"Now, you can return from certain death and keep trying",\
"As long as the totem is set in stone..."\
]

func _ready() -> void:
	ui.show_messages(intro)
