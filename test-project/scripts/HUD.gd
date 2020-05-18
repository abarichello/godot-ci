extends Control

func _ready():
	pass

# --- Signals ---

func _on_Theme_Button_pressed(button_index: int) -> void:
	GLOBAL.update_global_theme(button_index)

func _on_StartButton_pressed():
	get_node("/root/Main").emit_signal("start_zoom_out")
	get_node("/root/Main/Game/EnemyGenerator").emit_signal("start")
	get_node("/root/Main/Game/Player").emit_signal("unblock")
	self.hide()
