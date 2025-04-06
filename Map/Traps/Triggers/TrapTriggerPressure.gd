class_name TrapTriggerPressure extends TrapTrigger

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var trap_area_3d: Area3D = $Trap_Area3D
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

@export var time_to_trigger: float = 0.35
@export var time_to_untrigger: float = 0.5

var is_triggered: bool = false
var is_being_triggered: bool = false
var trigger_start: float
var untrigger_start: float
var is_being_untriggered: bool = false

func _physics_process(_delta: float) -> void:
	if is_triggered:
		##wait until there is nothing on top
		if not is_being_untriggered:
			if trap_area_3d.get_overlapping_bodies().size() == 0:
				is_being_untriggered = true
				untrigger_start = Time.get_ticks_msec()
			else:
				is_being_untriggered = false
		else:
			if trap_area_3d.get_overlapping_bodies().size() == 0:
				var time_diff: float = Time.get_ticks_msec() - untrigger_start
				if time_diff >= time_to_untrigger:
					untriggered()
			else:
				is_being_untriggered = false
		return
		
	if not is_being_triggered:
		if trap_area_3d.get_overlapping_bodies().size() > 0:
			is_being_triggered = true
			trigger_start = Time.get_ticks_msec()
		else: 
			is_being_triggered = false
	
	elif is_being_triggered:
		if trap_area_3d.get_overlapping_bodies().size() > 0:
			var time_diff: float = Time.get_ticks_msec() - trigger_start
			if time_diff >= time_to_trigger:
				triggered()
		else:
			is_being_triggered = false
	

func triggered() -> void:
	if is_triggered:
		return
	if not audio_stream_player_3d.playing:
		audio_stream_player_3d.play()
	is_triggered = true
	animation_player.play("trigger")
	on_triggered.emit()
	
func untriggered() -> void:
	if not is_triggered:
		return
	is_triggered = false
	animation_player.play("untrigger")
	on_untriggered.emit()
