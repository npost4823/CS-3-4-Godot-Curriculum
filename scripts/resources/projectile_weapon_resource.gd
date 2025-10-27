extends WeaponResource
class_name ProjectileWeaponResource

## Specialized weapon that shoots projectiles
## This is the main example students will learn from and duplicate
## Students will create variations by changing projectile_texture, damage, speed, etc.

@export_group("Projectile Properties")
## The visual appearance of the projectile
@export var projectile_texture: Texture2D

## How fast the projectile travels (pixels per second)
@export var projectile_speed: float = 400.0

## Size of the projectile sprite
@export var projectile_scale: Vector2 = Vector2(1.0, 1.0)

## How long the projectile exists before disappearing (seconds)
@export var projectile_lifetime: float = 3.0

## Does the projectile pierce through enemies?
@export var piercing: bool = false

## How many enemies can it hit before disappearing? (only if piercing = true)
@export var max_pierces: int = 1

@export_group("Multi-Shot Properties")
## How many projectiles are fired at once?
@export var projectile_count: int = 1

## Angle spread between projectiles when multiple are fired
@export var spread_angle: float = 15.0

@export_group("Visual Effects")
## Particle effect when projectile spawns (future feature)
@export var spawn_effect: PackedScene

## Particle effect when projectile hits enemy (future feature)
@export var impact_effect: PackedScene

## Should the projectile rotate to match its direction?
@export var rotate_sprite: bool = true


## This gets called when the weapon fires
## It will instantiate projectiles in the game world
func fire(shooter: Node2D, target_direction: Vector2) -> void:
	# This will be implemented by the weapon manager
	# The actual projectile spawning happens in the weapon_system.gd
	pass


## Returns data package for spawning a projectile
## This is used by the WeaponSystem to create projectiles
func get_projectile_data() -> Dictionary:
	return {
		"texture": projectile_texture,
		"damage": base_damage,
		"speed": projectile_speed,
		"scale": projectile_scale,
		"lifetime": projectile_lifetime,
		"piercing": piercing,
		"max_pierces": max_pierces,
		"rotate_sprite": rotate_sprite,
		"accuracy_spread": accuracy_spread
	}
