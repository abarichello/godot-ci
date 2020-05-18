extends "res://scripts/ColoredEntity.gd"

const FULL_HEALTH: int = 3
var health: int = self.FULL_HEALTH

func _ready():
	self.highlight()

func hit() -> void:
	if health > 1:
		self.health -= 1
	else:
		self.dead()

func dead() -> void:
	pass

# --- Signals ---

func _on_Body_body_entered(body: Node):
	body.queue_free()
	self.hit()
