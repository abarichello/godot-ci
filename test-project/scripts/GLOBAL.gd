extends Node

enum SpriteType { BULLET = 0, MISSILE = 1 }

var theme_index: int = 0
var current_theme: Dictionary
var HIGHLIGHT: Color
var LOWLIGHT: Color

const COLORSET_PY: Dictionary = { "high": Color(1, 1, 0.25), "low": Color(0.50, 0, 1) }
const COLORSET_OB: Dictionary = { "high": Color(1, 0.56, 0), "low": Color(0, 0.40, 1) }
const COLORSET_PB: Dictionary = { "high": Color(1, 0.50, 1), "low": Color(0, 0.75, 1) }
const COLORS: Array = [
	COLORSET_PY,
	COLORSET_OB,
	COLORSET_PB
]

const DEF_SPEED: float = 5.0
const MISSILE_SPEED: Dictionary = { "min": 30, "max": 60 }
const BULLET_SPEED: float = 10.0

const LOW_COLLISION: int = 2
const HIGH_COLLISION: int = 3

func _ready():
	self.update_global_theme(self.theme_index)

func update_global_theme(index: int):
	self.theme_index = index
	self.current_theme = COLORS[theme_index]
	self.HIGHLIGHT = self.current_theme["high"]
	self.LOWLIGHT = self.current_theme["low"]
	self.update_colored_entities()

func update_colored_entities() -> void:
	var nodes: Array = self.get_tree().get_nodes_in_group("ColoredEntity")
	for node in nodes:
		node.update_color()

func swap_nodes_color() -> void:
	var nodes: Array = self.get_tree().get_nodes_in_group("ColoredEntity")
	for node in nodes:
		node.swap_color()
