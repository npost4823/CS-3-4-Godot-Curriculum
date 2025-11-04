extends Resource
class_name ProjectileResource

## Configuration resource for projectiles
## Defines all the properties of a projectile (visual, behavior, damage)
## Used by ProjectileWeaponResource to configure projectiles

@export_group("Visual Properties")
## The visual appearance of the projectile
@export var texture: Texture2D

## Size of the projectile sprite
@export var scale: Vector2 = Vector2(1.0, 1.0)

## Should the projectile rotate to match its direction?
@export var rotate_sprite: bool = true

@export_group("Movement Properties")
## How fast the projectile travels (pixels per second)
@export var speed: float = 400.0

## How long the projectile exists before disappearing (seconds)
@export var lifetime: float = 3.0

@export_group("Combat Properties")
## Base damage dealt to enemies
@export var damage: float = 10.0

## Does the projectile pierce through enemies?
@export var piercing: bool = false

## How many enemies can it hit before disappearing? (only if piercing = true)
@export var max_pierces: int = 1

@export_group("Effects (Future)")
## Particle effect when projectile spawns
@export var spawn_effect: PackedScene

## Particle effect when projectile hits enemy
@export var impact_effect: PackedScene
