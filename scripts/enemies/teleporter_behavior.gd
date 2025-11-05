extends EnemyBehavior

## ============================================================================
## TELEPORTER BEHAVIOR - Example: Enemy teleports near player
## ============================================================================
##
## WHAT THIS DOES:
## Enemy doesn't move normally - instead, it teleports to random positions
## near the player on a cooldown. Creates unpredictable, hit-and-run enemies.
##
## HOW TO USE:
##   1. Open an enemy resource (.tres file)
##   2. Assign this script to "Custom Behavior Script"
##   3. Enemy will teleport around the player!
##
## EXPERIMENT:
##   - Change teleport_cooldown for more/less frequent teleports
##   - Change distance min/max for closer/further teleports
##   - ADVANCED: Add visual effects before teleporting!
##
## LEARN FROM THIS:
##   - Timer/cooldown patterns (time_since_teleport)
##   - Random positioning with randf() and randf_range()
##   - Polar coordinates (angle + distance)
##   - Instant position changes vs smooth movement
##
## ============================================================================

## How many seconds between teleports
@export var teleport_cooldown: float = 3.0

## Minimum distance from player to teleport to
@export var teleport_distance_min: float = 100.0

## Maximum distance from player to teleport to
@export var teleport_distance_max: float = 250.0

## How long to wait before first teleport
@export var initial_delay: float = 1.0

# Internal state
var time_since_teleport: float = 0.0
var has_teleported_once: bool = false


## Override behavior to implement teleporting
func process_behavior(delta: float) -> Vector2:
	if not player or not is_instance_valid(player):
		return Vector2.ZERO

	var distance_to_player = enemy.global_position.distance_to(player.global_position)

	# Only teleport if player is in detection range
	if distance_to_player > enemy.detection_range:
		return Vector2.ZERO

	# Update teleport timer
	time_since_teleport += delta

	# Check if it's time to teleport
	var ready_to_teleport = false
	if not has_teleported_once:
		# First teleport uses initial_delay
		ready_to_teleport = time_since_teleport >= initial_delay
	else:
		# Subsequent teleports use teleport_cooldown
		ready_to_teleport = time_since_teleport >= teleport_cooldown

	if ready_to_teleport:
		_teleport_near_player()
		time_since_teleport = 0.0
		has_teleported_once = true

	# After teleporting, enemy stands still (you could make it chase slowly instead)
	return Vector2.ZERO


## Teleport to a random position around the player
func _teleport_near_player() -> void:
	# Pick a random angle around the player
	var random_angle = randf() * TAU  # TAU = 2*PI (full circle in radians)

	# Pick a random distance within the min/max range
	var random_distance = randf_range(teleport_distance_min, teleport_distance_max)

	# Calculate the teleport position
	var offset = Vector2(
		cos(random_angle) * random_distance,
		sin(random_angle) * random_distance
	)

	# Teleport!
	enemy.global_position = player.global_position + offset

	# Optional: Add visual/sound effect here
	# Example: enemy.sprite.modulate = Color.CYAN
	# Then fade back to white over time


## Optional: Override attack behavior
## Teleporting enemies could have special attacks
func process_attack(delta: float) -> void:
	# You could add a ranged attack here
	# Or make the enemy shoot projectiles after teleporting
	pass
