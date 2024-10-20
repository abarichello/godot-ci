extends RigidBody2D

var MissileSprite: Texture2D = load("res://resources/img/missile-placeholder.png")
var BulletSprite: Texture2D = load("res://resources/img/bullet-placeholder.png")

var bodies_in_area: Array = []
var sprite_type: int
var speed: float = GLOBAL.DEF_SPEED
var armed: bool = false

func _ready():
	self.gravity_scale = 0.0
	self.physics_material_override.friction = 0.0
	self.contact_monitor = true
	self.max_contacts_reported = 1

func setup(sprite_type: int, speed: float) -> void:
	self.sprite_type = sprite_type
	self.speed = speed

	if sprite_type == GLOBAL.SpriteType.BULLET:
		$Mask/Sprite2D.set_texture(self.BulletSprite)
		self.armed = true
		$ExplosionArea/ExplosionShape.disabled = false
	else:
		$Mask/Sprite2D.set_texture(self.MissileSprite)

func shoot(at: Vector2) -> void:
	var direction = (at - self.global_position)
	self.linear_velocity = at * speed

func shoot_missile(at: Vector2) -> void:
	var direction = (at - self.global_position)
	self.apply_central_force(at * GLOBAL.MISSILE_SPEED["max"])

func set_random_color() -> void:
	$Mask.set_random_color()

func update_collision_layer() -> void:
	if $Mask.highlighted:
		self.set_collision_layer_value(GLOBAL.HIGH_COLLISION, 1)
		self.set_collision_mask_value(GLOBAL.HIGH_COLLISION, 1)
		$ExplosionArea.set_collision_layer_value(GLOBAL.HIGH_COLLISION, 1)
		$ExplosionArea.set_collision_mask_value(GLOBAL.HIGH_COLLISION, 1)
	else:
		self.set_collision_layer_value(GLOBAL.LOW_COLLISION, 1)
		self.set_collision_mask_value(GLOBAL.LOW_COLLISION, 1)
		$ExplosionArea.set_collision_layer_value(GLOBAL.LOW_COLLISION, 1)
		$ExplosionArea.set_collision_mask_value(GLOBAL.LOW_COLLISION, 1)

# --- Signals ---

func _on_VisibilityNotifier2D_screen_exited():
	self.queue_free()

func _on_Projectile_body_entered(body: PhysicsBody2D):
	if armed:
		for missile in bodies_in_area:
			missile.queue_free()
		self.queue_free()

func _on_ExplosionArea_body_entered(body: PhysicsBody2D):
	if armed and body.get_node("Mask").highlighted == $Mask.highlighted:
		bodies_in_area.push_front(body)

func _on_ExplosionArea_body_exited(body: PhysicsBody2D):
	if armed:
		bodies_in_area.erase(body)
