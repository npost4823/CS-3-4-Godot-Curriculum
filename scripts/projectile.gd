extends Area2D
class_name Projectile

## A projectile fired from weapons
## This script handles movement, collision with enemies, and dealing damage
## The projectile's properties are set from the ProjectileWeaponResource

var damage: float = 10.0
var speed: float = 400.0
var direction: Vector2 = Vector2.RIGHT
var lifetime: float = 3.0
var piercing: bool = false
var max_pierces: int = 1
var pierce_count: int = 0

var lifetime_timer: float = 0.0


func _ready() -> void:
	# Connect to collision signals
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)


func _process(delta: float) -> void:
	# Move the projectile
	position += direction * speed * delta

	# Track lifetime and destroy when expired
	lifetime_timer += delta
	if lifetime_timer >= lifetime:
		queue_free()


## Initialize the projectile with data from a ProjectileWeaponResource
func setup(projectile_data: Dictionary) -> void:
	damage = projectile_data.get("damage", 10.0)
	speed = projectile_data.get("speed", 400.0)
	lifetime = projectile_data.get("lifetime", 3.0)
	piercing = projectile_data.get("piercing", false)
	max_pierces = projectile_data.get("max_pierces", 1)

	# Setup visual
	var sprite = get_node_or_null("Sprite2D")
	if sprite and projectile_data.has("texture"):
		sprite.texture = projectile_data.get("texture")
		sprite.scale = projectile_data.get("scale", Vector2.ONE)

	# Rotate sprite to match direction if enabled
	if projectile_data.get("rotate_sprite", true):
		rotation = direction.angle()


## Called when projectile hits something
func _on_body_entered(body: Node2D) -> void:
	# Check if we hit an enemy
	if body.has_method("take_damage"):
		body.take_damage(damage)
		_handle_hit()


## Called when projectile hits an Area2D
func _on_area_entered(area: Area2D) -> void:
	# Check if we hit an enemy (some enemies might be Area2D)
	if area.has_method("take_damage"):
		area.take_damage(damage)
		_handle_hit()


## Handle what happens when projectile hits something
func _handle_hit() -> void:
	if piercing:
		pierce_count += 1
		if pierce_count >= max_pierces:
			queue_free()
	else:
		# Non-piercing projectiles are destroyed on first hit
		queue_free()
