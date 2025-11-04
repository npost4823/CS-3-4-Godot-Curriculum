extends WeaponResource
class_name ProjectileWeaponResource

## Specialized weapon that shoots projectiles
## This is the main example students will learn from and duplicate
## Students will create variations by changing the projectile_config and multi-shot properties

@export_group("Projectile Configuration")
## The projectile configuration resource
## Create different projectile types by making new ProjectileResource files
@export var projectile_config: ProjectileResource

@export_group("Multi-Shot Properties")
## How many projectiles are fired at once?
@export var projectile_count: int = 1

## Angle spread between projectiles when multiple are fired
@export var spread_angle: float = 15.0


## This gets called when the weapon fires
## It will instantiate projectiles in the game world
func fire(_shooter: Node2D, _target_direction: Vector2) -> void:
	# This will be implemented by the weapon manager
	# The actual projectile spawning happens in the weapon_system.gd
	pass
