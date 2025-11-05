extends Resource
class_name ProjectileResource

## ============================================================================
## PROJECTILE RESOURCE - Data for projectile appearance and behavior
## ============================================================================
##
## WHAT THIS SCRIPT DOES:
## This is a RESOURCE SCRIPT that defines how projectiles look and behave
## (bullets, arrows, fireballs, etc.). Projectiles are the objects that
## weapons shoot at enemies.
##
## This resource works with:
## - scenes/projectile.tscn (the projectile scene template)
## - scripts/projectile.gd (reads this data to configure projectiles)
## - ProjectileWeaponResource (weapons reference this to know what to shoot)
##
## ============================================================================
## HOW TO CREATE NEW PROJECTILE TYPES (NO CODE CHANGES NEEDED):
## ============================================================================
##
## 1. In Godot editor, navigate to: resources/projectiles/
##
## 2. Right-click on basic_projectile.tres and select "Duplicate"
##
## 3. Rename it (e.g., "heavy_bullet.tres", "fireball.tres")
##
## 4. Double-click to open in Inspector and modify properties:
##
##    EXAMPLES:
##
##    Fast Bullet:
##    - speed: 800
##    - damage: 5
##    - lifetime: 2.0
##    - scale: Vector2(0.5, 0.5) (small)
##
##    Slow Heavy Projectile:
##    - speed: 200
##    - damage: 25
##    - lifetime: 5.0
##    - scale: Vector2(2.0, 2.0) (large)
##
##    Piercing Arrow:
##    - piercing: true
##    - max_pierces: 3
##    - speed: 600
##    - damage: 15
##
## 5. Assign to a weapon:
##    - Open your weapon resource (e.g., resources/weapons/your_weapon.tres)
##    - Set "Projectile Config" to your new projectile resource
##
## 6. Test by equipping that weapon and playing!
##
## NO CODE CHANGES REQUIRED - Just duplicate .tres files and change values!
##
## ============================================================================

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

## ============================================================================
## FUTURE FEATURE: Area Effect Scripts (Similar to Enemy Behaviors)
## ============================================================================
##
## IDEA: Just like enemies can have custom_behavior_script for special AI,
## projectiles could have effect_script for area effects (explosions, poison
## clouds, slow zones, etc.)
##
## TO IMPLEMENT THIS FEATURE:
##
## 1. Add this field below:
##    @export var effect_script: GDScript
##
## 2. Create base class scripts/projectile_effect.gd:
##    extends Node
##    class_name ProjectileEffect
##
##    var projectile: Projectile = null
##    var impact_position: Vector2 = Vector2.ZERO
##
##    func initialize(proj: Projectile, pos: Vector2) -> void:
##        projectile = proj
##        impact_position = pos
##
##    # Override this in child classes
##    func trigger_effect() -> void:
##        pass
##
## 3. Modify projectile.gd to use effect scripts:
##    - In _on_body_entered(), after dealing damage
##    - Check if projectile_data.effect_script exists
##    - Instantiate and call trigger_effect()
##
## 4. Create example effects:
##    - explosion_effect.gd - Damage all enemies in radius
##    - poison_cloud_effect.gd - Spawn lingering damage zone
##    - freeze_effect.gd - Slow enemies for a duration
##    - chain_lightning_effect.gd - Jump to nearby enemies
##
## EXAMPLE: scripts/effects/explosion_effect.gd
##    extends ProjectileEffect
##
##    @export var explosion_radius: float = 100.0
##    @export var explosion_damage: float = 20.0
##
##    func trigger_effect() -> void:
##        var enemies = get_tree().get_nodes_in_group("enemies")
##        for enemy in enemies:
##            var distance = impact_position.distance_to(enemy.global_position)
##            if distance <= explosion_radius:
##                enemy.take_damage(explosion_damage)
##
## This would be an ADVANCED lesson combining:
##   - Script inheritance (like enemy behaviors)
##   - Area detection
##   - Delayed effects
##   - Visual effects
##
## ============================================================================
