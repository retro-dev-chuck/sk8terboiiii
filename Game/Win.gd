class_name Win extends Area3D
@onready var full_sc_ui: FullScUi = %FullScUi

func _ready() -> void:
	body_entered.connect(_check_if_has_arkenstone)
	
func _check_if_has_arkenstone(body: Node3D) -> void:
	if State.has_amberstone and !State.is_game_over:
		State.is_game_over = true
		full_sc_ui.show_msg("Congratulations!")
		Events.on_game_over.emit(2)
		
