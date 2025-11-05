extends EnemyBehavior

## Example custom behavior: Enemy flees when health is low
##
## TEACHING NOTE: This shows how custom behaviors can react to enemy state
## The enemy acts normally when healthy, but runs away when low on health
##
## To use this behavior:
## 1. Open an EnemyResource (.tres file)
## 2. Assign this script to "Custom Behavior Script"
## 3. The enemy will flee when below flee_health_percent
##
## EXPERIMENT: Change flee_health_percent to make enemies braver or more cowardly
## Try adding flee_speed_boost to make them run faster when scared!

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
