extends Resource
class_name EnemyResource

## Configuration resource for enemy types
## Students will duplicate this to create different enemy variants
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
@export var can_attack: bool = false

@export_group("Wave Spawning")
## What wave does this enemy first appear in?
@export var unlock_wave: int = 1

## How common is this enemy in spawns? (higher = more common)
@export var spawn_weight: int = 10


## Calculate actual stats based on wave difficulty scaling
func get_scaled_stats(wave_number: int) -> Dictionary:
	var wave_multiplier = 1.0 + (wave_number - 1) * 0.15  # 15% increase per wave

	return {
		"max_health": max_health * wave_multiplier,
		"contact_damage": contact_damage * wave_multiplier,
		"move_speed": move_speed * min(1.5, 1.0 + (wave_number - 1) * 0.05),  # Speed caps at 1.5x
		"xp_value": int(xp_value * wave_multiplier)
	}
