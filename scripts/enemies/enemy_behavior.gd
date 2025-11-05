extends Node
class_name EnemyBehavior

## Base class for custom enemy behaviors
## Students create custom behaviors by:
## 1. Creating a new .gd file that extends EnemyBehavior
## 2. Overriding process_behavior() to define movement/attack logic
## 3. Assigning the script to an EnemyResource's custom_behavior_script field
##
## TEACHING NOTE: Custom behaviors give students complete control over enemy AI
## Examples: circling enemies, teleporting enemies, enemies that flee when low health

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
