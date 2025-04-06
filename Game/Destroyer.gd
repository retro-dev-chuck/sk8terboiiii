class_name Destroyer extends Area3D

func _ready() -> void:
	body_entered.connect(_kill)
	
func _kill(body: Node3D) -> void:
	body.queue_free()
