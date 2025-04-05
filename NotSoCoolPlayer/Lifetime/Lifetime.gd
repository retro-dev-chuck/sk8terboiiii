class_name Lifetime extends Node3D

signal on_timer_finished()

@export var timer: Timer

func _ready() -> void:
	timer.timeout.connect(_on_timer_finished)
	
func start(time: float) -> void:
	if not timer.is_stopped():
		timer.stop()
	timer.start(time)
	
func _on_timer_finished() -> void:
	on_timer_finished.emit()
