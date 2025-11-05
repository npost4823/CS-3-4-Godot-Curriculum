extends Resource
class_name EnemyResource

## Configuration resource for enemy types
## Works with scenes/enemies/enemy.tscn (generic template scene)
## Students create new enemy types by duplicating existing .tres files
##
## TEACHING NOTE: To create a new enemy:
## 1. Right-click in resources/enemies/ folder
## 2. Duplicate an existing enemy resource (e.g., basic_slime.tres)
## 3. Rename it (e.g., flying_bat.tres)
## 4. Modify the properties (texture, stats, behavior)
## 5. Add to WaveSpawner's available_enemies array
## Example: Fast/weak enemies vs slow/strong enemies

@export_group("Enemy Identity")
## Unique identifier for this enemy type
@export var enemy_id: String = ""

## Display name for this enemy
@export var enemy_name: String = "Unknown Enemy"

## The visual sprite for this enemy
@export var enemy_texture: Texture2D

## Optional: AnimatedSprite frames if using animations
@export var animated_frames: SpriteFrames

## Visual scale (1.0 = normal size, 2.0 = double size, 0.5 = half size)
@export var sprite_scale: float = 1.0

@export_group("Combat Stats")
## Maximum health points
@export var max_health: float = 50.0

## How much damage this enemy deals on contact
@export var contact_damage: float = 10.0

## Movement speed (pixels per second)
@export var move_speed: float = 100.0

## How close enemy needs to be to start chasing player
@export var detection_range: float = 1000.0

@export_group("Reward Drops")
## Base XP awarded when killed
@export var xp_value: int = 10

@export_group("Behavior Properties")
## Does this enemy avoid getting too close to other enemies?
@export var uses_separation: bool = true

## Separation radius from other enemies
@export var separation_distance: float = 30.0

## Can this enemy attack? (future: ranged enemies)
@export var can_attack: bool = true

## Optional: Custom behavior script that overrides default enemy behavior
## Leave empty to use default chase-player behavior
## Assign a GDScript (.gd file) that extends EnemyBehavior to customize movement/attacks
@export var custom_behavior_script: GDScript

@export_group("Wave Spawning")
## What wave does this enemy first appear in?
@export var unlock_wave: int = 1

## How common is this enemy in spawns? (higher = more common)
@export var spawn_weight: int = 10

## Credit cost to spawn this enemy (higher = more expensive/powerful)
@export var credit_cost: int = 10


## Calculate scaled health based on wave number
## Returns health with 15% increase per wave
func get_scaled_health(wave_number: int) -> float:
	var wave_multiplier = 1.0 + (wave_number - 1) * 0.15
	return max_health * wave_multiplier


## Calculate scaled contact damage based on wave number
## Returns damage with 15% increase per wave
func get_scaled_damage(wave_number: int) -> float:
	var wave_multiplier = 1.0 + (wave_number - 1) * 0.15
	return contact_damage * wave_multiplier


## Calculate scaled move speed based on wave number
## Returns speed with 5% increase per wave, capped at 1.5x
func get_scaled_speed(wave_number: int) -> float:
	return move_speed * min(1.5, 1.0 + (wave_number - 1) * 0.05)


## Calculate scaled XP value based on wave number
## Returns XP with 15% increase per wave
func get_scaled_xp(wave_number: int) -> int:
	var wave_multiplier = 1.0 + (wave_number - 1) * 0.15
	return int(xp_value * wave_multiplier)
