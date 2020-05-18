# Class with common color switch operations.
# Add to the group ColoredEntity if its color is not fixed and gets swapped with player input.
extends Node2D

var current_color: Color = GLOBAL.LOWLIGHT
var highlighted: bool = false

func _ready():
	self.update_color()

func update_color() -> void:
	if highlighted:
		self.current_color = GLOBAL.HIGHLIGHT
	else:
		self.current_color = GLOBAL.LOWLIGHT
	self.modulate = self.current_color

func swap_color() -> void:
	if current_color == GLOBAL.LOWLIGHT:
		self.highlight()
	else:
		self.lowlight()

func highlight():
	current_color = GLOBAL.HIGHLIGHT
	highlighted = true
	self.update_color()

func lowlight():
	current_color = GLOBAL.LOWLIGHT
	highlighted = false
	self.update_color()

func set_random_color() -> void:
	randomize()
	if randi() % 2 == 0:
		self.swap_color()
