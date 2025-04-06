class_name SpearTrap extends Node3D

@export var trap_trigger: TrapTrigger
@export var killzone: KillZone
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if not trap_trigger:
		push_error("trap has no trigger! won't work")
		return
	trap_trigger.on_triggered.connect(_on_trap_triggered)
	trap_trigger.on_untriggered.connect(_on_trap_untriggered)

func _on_trap_triggered() -> void:
	killzone.activate()
	animation_player.play("activate")
	
func _on_trap_untriggered() -> void:
	animation_player.play("deactivate")
