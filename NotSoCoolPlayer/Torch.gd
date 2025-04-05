class_name Torch extends OmniLight3D

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Toggle_Torch"):
		visible = !visible
