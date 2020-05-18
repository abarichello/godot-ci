extends "res://scripts/ColoredEntity.gd"

signal unblock

var blocked_controls: bool = true

func _ready():
	self.highlight()

func _input(event):
	if blocked_controls:
		return

	if Input.is_action_just_pressed("swap"):
		GLOBAL.swap_nodes_color()
	if Input.is_action_pressed("fire"):
		self.shoot_bullet()

func shoot_bullet() -> void:
	$Cannon.shoot()

# --- Signals ---

func _on_Player_unblock():
	self.blocked_controls = false
