extends Area2D
class_name Projectile

## ============================================================================
## PROJECTILE - Bullets, arrows, and other projectiles
## ============================================================================
##
## WHAT THIS SCRIPT DOES:
## This script controls individual projectiles (bullets, arrows, etc.) after
## they're fired by the weapon system. It handles:
## - Moving in a direction at a certain speed
## - Rotating to face the direction of travel
## - Hitting enemies and dealing damage
## - Piercing through multiple enemies (if enabled)
## - Destroying itself after lifetime expires or hitting enemies
##
## This script works with:
## - resources/projectiles/*.tres (ProjectileResource data)
## - scripts/weapon_system.gd (creates and fires projectiles)
## - scripts/enemies/enemy_base.gd (takes damage when hit)
##
## ============================================================================
## HOW TO CREATE NEW PROJECTILE TYPES:
## ============================================================================
##
## You DON'T modify this script! Instead:
##   - See projectile_resource.gd for instructions
##   - Just duplicate .tres files to create new projectile types
##
## ============================================================================
## ADVANCED: Modifying Projectile Behavior
## ============================================================================
##
## Add homing projectiles:
##   - Modify _process() to adjust direction toward nearest enemy
##
## Add projectile effects:
##   - Add particle systems or trails
##   - Spawn impact effects when hitting enemies
##
## Add bounce/ricochet:
##   - Detect when projectile hits walls
##   - Reflect direction vector
##
## Add area damage:
##   - When projectile hits, damage all enemies in a radius
##   - Use get_overlapping_bodies() to find enemies
##
## Add status effects:
##   - Pass additional data to enemy.take_damage()
##   - Apply slow, poison, freeze, etc.
##
## ============================================================================
## ADVANCED PROJECT: Custom Effect Scripts (Like Enemy Behaviors)
## ============================================================================
##
## SEE DETAILED IMPLEMENTATION GUIDE IN:
##   - projectile_resource.gd (lines ~94-152)
##   - Comments in setup() function below (lines ~117-128)
##   - Comments in _handle_hit() function below (lines ~149-164)
##
## This would create a system similar to enemy custom behaviors, but for
## projectile area effects (explosions, poison clouds, chain lightning, etc.)
##
## PERFECT for an advanced lesson combining:
##   - Everything learned from enemy behaviors
##   - Area detection and radius calculations
##   - Spawning persistent effects (damage zones)
##   - Creating complex weapon types
##
## ============================================================================

var damage: float = 10.0
var speed: float = 400.0
var direction: Vector2 = Vector2.RIGHT
var lifetime: float = 3.0
var piercing: bool = false
var max_pierces: int = 1
var pierce_count: int = 0

var lifetime_timer: float = 0.0

## Reference to ProjectileResource (for accessing effect_script)
var projectile_data: ProjectileResource = null

## ============================================================================
## FUTURE: Custom effect instance (similar to enemy custom_behavior)
## ============================================================================
## When implementing effect scripts (see projectile_resource.gd):
## var custom_effect: ProjectileEffect = null
## ============================================================================


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


## Initialize the projectile with data from a ProjectileResource
func setup(projectile_config: ProjectileResource, damageAddend) -> void:
	if not projectile_config:
		push_error("Projectile setup called with null ProjectileResource")
		return

	# Store reference to resource for effect scripts
	projectile_data = projectile_config

	damage = projectile_config.damage + damageAddend
	speed = projectile_config.speed
	lifetime = projectile_config.lifetime
	piercing = projectile_config.piercing
	max_pierces = projectile_config.max_pierces

	# Setup visual
	var sprite = get_node_or_null("Sprite2D")
	if sprite and projectile_config.texture:
		sprite.texture = projectile_config.texture
		sprite.scale = projectile_config.scale

	# Rotate sprite to match direction if enabled
	if projectile_config.rotate_sprite:
		rotation = direction.angle()

	## ========================================================================
	## FUTURE: Load effect script here (similar to enemy_base.gd)
	## ========================================================================
	## if projectile_config.effect_script:
	##     custom_effect = projectile_config.effect_script.new()
	##     if custom_effect and custom_effect is ProjectileEffect:
	##         add_child(custom_effect)
	##         custom_effect.initialize(self, global_position)
	##     else:
	##         push_error("Effect script must extend ProjectileEffect")
	##         custom_effect = null
	## ========================================================================


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
	## ========================================================================
	## FUTURE: Trigger effect script here
	## ========================================================================
	## This is where area effects would trigger (explosions, poison, etc.)
	##
	## if custom_effect:
	##     custom_effect.impact_position = global_position
	##     custom_effect.trigger_effect()
	##
	## Examples of what this could do:
	##   - Explosion: Damage all enemies within radius
	##   - Poison Cloud: Spawn Area2D that damages over time
	##   - Freeze: Apply slow effect to hit enemy
	##   - Chain Lightning: Find nearest enemies and create projectiles to them
	##   - Knockback: Push enemies away from impact point
	## ========================================================================

	if piercing:
		pierce_count += 1
		if pierce_count >= max_pierces:
			queue_free()
	else:
		# Non-piercing projectiles are destroyed on first hit
		queue_free()
