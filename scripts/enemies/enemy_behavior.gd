extends Node
class_name EnemyBehavior

## ============================================================================
## ENEMY BEHAVIOR - Base class for custom enemy AI behaviors
## ============================================================================
##
## WHAT THIS SCRIPT DOES:
## This is a BASE CLASS for creating custom enemy behaviors. By default,
## all enemies chase the player. But if you want enemies with special AI
## (circling, fleeing, teleporting, etc.), you create a script that extends
## this class.
##
## This script works with:
## - scripts/enemies/enemy_base.gd (uses behavior scripts if assigned)
## - resources/enemies/*.tres (EnemyResource assigns behavior to enemies)
##
## ============================================================================
## HOW TO CREATE CUSTOM ENEMY BEHAVIORS:
## ============================================================================
##
## STEP 1: Create a new behavior script
##   - In scripts/enemies/ folder, create new script (e.g., "zigzag_behavior.gd")
##   - Start with: extends EnemyBehavior
##
## STEP 2: Override process_behavior() function
##   - This function is called every frame
##   - Return a Vector2 for the enemy's velocity
##   - You have access to:
##     - self.enemy (the enemy this behavior controls)
##     - self.player (the player character)
##
## STEP 3: Assign behavior to an enemy resource
##   - Open your enemy resource (.tres file)
##   - Find "Custom Behavior Script" field
##   - Assign your new behavior script
##
## EXAMPLE behaviors included:
##   - circling_behavior.gd - Orbits around player
##   - coward_behavior.gd - Flees when health is low
##   - teleporter_behavior.gd - Teleports near player periodically
##
## ============================================================================
## HELPER FUNCTIONS AVAILABLE:
## ============================================================================
##
## apply_separation(direction) - Avoid clustering with other enemies
## update_sprite_flip(direction) - Flip sprite to face movement direction
##
## You can access enemy properties:
##   - enemy.global_position
##   - enemy.move_speed
##   - enemy.current_health / enemy.max_health
##   - enemy.detection_range
##   - enemy.enemy_data (the resource)
##
## You can access player properties:
##   - player.global_position
##   - player.current_health
##
## ============================================================================
## EXAMPLES OF CUSTOM BEHAVIORS TO CREATE:
## ============================================================================
##
## Zigzag movement:
##   - Alternate moving left/right while approaching player
##
## Charge attack:
##   - Move slowly until close, then charge at high speed
##
## Hit and run:
##   - Approach player, attack, then retreat for a few seconds
##
## Ranged enemy:
##   - Keep distance from player, spawn projectiles
##
## Patrol:
##   - Move between waypoints, only chase if player gets close
##
## ============================================================================

## Reference to the enemy this behavior controls
var enemy: EnemyBase = null

## Reference to the player (set automatically)
var player: Player = null

## Called when behavior is first attached to an enemy
func initialize(enemy_node: EnemyBase, player_node: Player) -> void:
	enemy = enemy_node
	player = player_node


## Override this function to define custom movement/attack behavior
## Called every physics frame (delta is time since last frame)
## Return the velocity vector the enemy should move with
## Default implementation: chase the player (same as base enemy behavior)
func process_behavior(delta: float) -> Vector2:
	if not player or not is_instance_valid(player):
		return Vector2.ZERO

	# Check if player is in detection range
	var distance_to_player = enemy.global_position.distance_to(player.global_position)

	if distance_to_player <= enemy.detection_range:
		# Move toward player
		var direction_to_player = (player.global_position - enemy.global_position).normalized()

		# Apply separation from other enemies if enabled
		if enemy.enemy_data and enemy.enemy_data.uses_separation:
			direction_to_player = apply_separation(direction_to_player)

		return direction_to_player * enemy.move_speed

	return Vector2.ZERO


## Helper function: Apply separation force to avoid enemy clustering
## You can call this from your custom behavior or implement your own
func apply_separation(current_direction: Vector2) -> Vector2:
	var separation_force = Vector2.ZERO
	var nearby_enemies = enemy.get_tree().get_nodes_in_group("enemies")

	for other_enemy in nearby_enemies:
		if other_enemy == enemy or not other_enemy is Node2D:
			continue

		var distance = enemy.global_position.distance_to(other_enemy.global_position)
		if distance < enemy.enemy_data.separation_distance and distance > 0:
			var away_vector = (enemy.global_position - other_enemy.global_position).normalized()
			separation_force += away_vector / distance

	# Blend current direction with separation force
	var final_direction = (current_direction + separation_force * 0.5).normalized()
	return final_direction


## Helper function: Update sprite flip based on direction
## Call this if you want the sprite to face the direction of movement
func update_sprite_flip(direction: Vector2) -> void:
	if enemy.sprite and direction.x != 0:
		if enemy.sprite is Sprite2D:
			enemy.sprite.flip_h = direction.x < 0
		elif enemy.sprite is AnimatedSprite2D:
			enemy.sprite.flip_h = direction.x < 0


## Override this if your enemy has special attack behavior
## Called when enemy is close enough to attack
## Default: does nothing (contact damage is handled by enemy_base.gd)
func process_attack(delta: float) -> void:
	pass
