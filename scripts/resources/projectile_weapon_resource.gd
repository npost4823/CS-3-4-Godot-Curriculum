extends WeaponResource
class_name ProjectileWeaponResource

## ============================================================================
## PROJECTILE WEAPON RESOURCE - Weapons that fire projectiles
## ============================================================================
##
## WHAT THIS SCRIPT DOES:
## This is a RESOURCE SCRIPT that defines weapons that shoot projectiles
## (bullets, arrows, fireballs, etc.). It extends WeaponResource to add
## projectile-specific properties like multi-shot and spread.
##
## This resource works with:
## - scripts/weapon_system.gd (reads this data to fire projectiles)
## - ProjectileResource (defines what projectiles look/behave like)
##
## ============================================================================
## HOW TO CREATE NEW WEAPONS (NO CODE CHANGES NEEDED):
## ============================================================================
##
## 1. In Godot editor, navigate to: resources/weapons/
##
## 2. Right-click on basic_pistol.tres and select "Duplicate"
##
## 3. Rename it (e.g., "shotgun.tres", "sniper.tres", "machine_gun.tres")
##
## 4. Double-click to open in Inspector and modify properties
##
## 5. Assign to player:
##    - Open scenes/player.tscn
##    - Select WeaponSystem node
##    - In Inspector, set "Equipped Weapon" to your new weapon
##
## 6. Test by playing the game!
##
## NO CODE CHANGES REQUIRED - Just duplicate .tres files and change values!
##
## ============================================================================

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
