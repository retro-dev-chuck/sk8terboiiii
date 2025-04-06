class_name ThrowableTorch extends RigidBody3D

@export var lifetime: Lifetime
@export var interactable: Interactable
@export var light: Node3D
@export var pfx: Node3D
		
func thrown(duration_left: float) -> void:
	if duration_left < 1.0:
		_on_life_end()
		return
	if is_node_ready():
		lifetime.on_timer_finished.connect(_on_life_end)
		lifetime.start(duration_left)
	else:
		await ready
		lifetime.on_timer_finished.connect(_on_life_end)
		lifetime.start(duration_left)

func _on_life_end() -> void:
	if lifetime.on_timer_finished.is_connected(_on_life_end):
		lifetime.on_timer_finished.disconnect(_on_life_end)
	lifetime.timer.start(0.1)
	light.queue_free()
	pfx.queue_free()
