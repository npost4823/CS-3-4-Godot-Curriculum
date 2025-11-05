extends EnemyBehavior

## Example custom behavior: Enemy circles around the player
##
## TEACHING NOTE: This demonstrates how to override enemy behavior
## To use this:
## 1. Open an EnemyResource (.tres file) in the inspector
## 2. Find "Custom Behavior Script" under Behavior Properties
## 3. Drag this script file into that field (or click and select it)
## 4. The enemy will now circle the player instead of charging straight
##
## EXPERIMENT: Try changing orbit_radius, orbit_speed, or approach_distance
## to create different behavior patterns

## How far from the player the enemy tries to stay while circling
@export var orbit_radius: float = 150.0

## How fast the enemy circles (radians per second)
@export var orbit_speed: float = 2.0

## How close the enemy will get before it starts circling
@export var approach_distance: float = 200.0

# Internal tracking
var orbit_angle: float = 0.0


## Override the default movement behavior
func process_behavior(delta: float) -> Vector2:
	if not player or not is_instance_valid(player):
		return Vector2.ZERO

	var distance_to_player = enemy.global_position.distance_to(player.global_position)

	# Only move if player is in detection range
	if distance_to_player > enemy.detection_range:
		return Vector2.ZERO

	var direction_to_player = (player.global_position - enemy.global_position).normalized()
	var desired_velocity = Vector2.ZERO

	if distance_to_player > approach_distance:
		# If far away, move closer to the player
		desired_velocity = direction_to_player * enemy.move_speed
	else:
		# Close enough - start circling!
		# Update orbit angle to rotate around player
		orbit_angle += orbit_speed * delta

		# Calculate position on circle around player
		var orbit_offset = Vector2(
			cos(orbit_angle) * orbit_radius,
			sin(orbit_angle) * orbit_radius
		)

		# Desired position is player position + orbit offset
		var target_position = player.global_position + orbit_offset
		var direction_to_orbit = (target_position - enemy.global_position).normalized()

		desired_velocity = direction_to_orbit * enemy.move_speed

	# Apply separation to avoid clustering (optional - you can remove this)
	if enemy.enemy_data and enemy.enemy_data.uses_separation:
		var separation_direction = (desired_velocity.normalized() +
									 apply_separation(desired_velocity.normalized()) * 0.3).normalized()
		desired_velocity = separation_direction * desired_velocity.length()

	# Update sprite to face movement direction
	update_sprite_flip(desired_velocity)

	return desired_velocity
