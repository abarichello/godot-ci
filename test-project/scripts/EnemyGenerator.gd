extends Node2D

@onready var EnemyScene: PackedScene = preload("res://scenes/Projectile.tscn")
signal start
signal stop

var Enemy

func _ready():
	self.setup_enemy()
	self.emit_signal("stop")

func setup_enemy() -> void:
	self.Enemy = EnemyScene.instantiate()
	Enemy.setup(GLOBAL.SpriteType.MISSILE, GLOBAL.MISSILE_SPEED["max"])

func spawn_and_shoot_enemy() -> void:
	var Duplicate = Enemy.duplicate(Node.DUPLICATE_USE_INSTANTIATION)
	Duplicate.set_random_color()
	Duplicate.update_collision_layer()
	$Enemies.add_child(Duplicate)

	$SpawnArea/SpawnLocation.set_h_offset(randi())
	Duplicate.global_position = $SpawnArea/SpawnLocation.position

	var direction: Vector2 = (Vector2(0, 1080) - Duplicate.global_position).normalized()
	var angle: float = Vector2(1, 0).angle_to(direction)
	Duplicate.rotation = angle
	Duplicate.shoot_missile(direction)

# --- Signals ---

func _on_SpawnTimer_timeout():
	self.spawn_and_shoot_enemy()

func _on_EnemyGenerator_start():
	$SpawnTimer.start()

func _on_EnemyGenerator_stop():
	$SpawnTimer.stop()
