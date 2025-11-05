extends EnemyBehavior

## ============================================================================
## COWARD BEHAVIOR - Example: Enemy flees when health is low
## ============================================================================
##
## WHAT THIS DOES:
## Enemy acts normal when healthy, but runs away from player when health
## drops below a threshold. Demonstrates state-dependent AI.
##
## HOW TO USE:
##   1. Open an enemy resource (.tres file)
##   2. Find "Custom Behavior Script"
##   3. Assign this script
##   4. Enemy will flee when health drops below flee_health_percent!
##
## EXPERIMENT:
##   - Change flee_health_percent (0.3 = 30% health)
##   - Change flee_speed_boost for faster/slower fleeing
##   - Add a "brave threshold" where they re-engage
##
## LEARN FROM THIS:
##   - Reading enemy state (current_health / max_health)
##   - Conditional behavior based on health
##   - Inverting direction vectors (flee = opposite of chase)
##
## ============================================================================

## At what health percentage does the enemy start fleeing? (0.0 to 1.0)
@export var flee_health_percent: float = 0.3  # Flee at 30% health

## How much faster does the enemy move when fleeing? (1.0 = same speed, 2.0 = double speed)
@export var flee_speed_boost: float = 1.5


## Override movement to flee when low health
func process_behavior(delta: float) -> Vector2:
	if not player or not is_instance_valid(player):
		return Vector2.ZERO

	var distance_to_player = enemy.global_position.distance_to(player.global_position)

	# Only react if player is in detection range
	if distance_to_player > enemy.detection_range:
		return Vector2.ZERO

	# Calculate health percentage
	var health_percent = enemy.current_health / enemy.max_health

	var direction_to_player = (player.global_position - enemy.global_position).normalized()
	var desired_velocity = Vector2.ZERO

	if health_percent <= flee_health_percent:
		# LOW HEALTH - RUN AWAY!
		# Move in opposite direction from player
		var flee_direction = -direction_to_player
		var flee_speed = enemy.move_speed * flee_speed_boost

		# Apply separation so fleeing enemies don't clump together
		if enemy.enemy_data and enemy.enemy_data.uses_separation:
			flee_direction = apply_separation(flee_direction)

		desired_velocity = flee_direction * flee_speed
	else:
		# HEALTHY - chase the player normally
		# Apply separation to avoid clustering
		if enemy.enemy_data and enemy.enemy_data.uses_separation:
			direction_to_player = apply_separation(direction_to_player)

		desired_velocity = direction_to_player * enemy.move_speed

	# Update sprite to face movement direction
	update_sprite_flip(desired_velocity)

	return desired_velocity
