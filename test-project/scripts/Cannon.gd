extends "res://scripts/ColoredEntity.gd"

@onready var Bullet: PackedScene = preload("res://scenes/Projectile.tscn")
const RATE_OF_CHANGE: float = 0.9
const UPPER_LIMIT: int = -89
const LOWER_LIMIT: int = -5

var angle: float = -45.0

func _ready():
	self.highlight()

func _process(delta):
	$Sprite2D.set_rotation(deg_to_rad(self.angle))
	$Sprite2D.size.y = 24

func _input(event):
	if Input.is_action_pressed("ui_up"):
		if self.angle > UPPER_LIMIT:
			self.move_up()
	if Input.is_action_pressed("ui_down"):
		if self.angle < LOWER_LIMIT:
			self.move_down()

func move_up() -> void:
	self.angle -= RATE_OF_CHANGE

func move_down() -> void:
	self.angle += RATE_OF_CHANGE

func shoot() -> void:
	if $FireCooldown.time_left == 0:
		var NewBullet = Bullet.instantiate()
		NewBullet.global_position = $Sprite2D/CannonTip.global_position
		NewBullet.rotation_degrees = self.angle
		var at: Vector2 = $Sprite2D/CannonTip.global_position - $Sprite2D/CannonBase.global_position
		NewBullet.shoot(at)

		var BulletSprite = NewBullet.get_node("Mask")
		if self.highlighted:
			BulletSprite.highlight()
		else:
			BulletSprite.lowlight()

		NewBullet.setup(GLOBAL.SpriteType.BULLET, GLOBAL.BULLET_SPEED)
		NewBullet.update_collision_layer()
		$Projectiles.add_child(NewBullet)
		$FireCooldown.start()
