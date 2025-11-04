extends CharacterBody2D
class_name EnemyBase

## Base class for all enemies
## Works with scenes/enemies/enemy.tscn (generic template)
## The WaveSpawner instantiates the template and calls load_from_resource()
## This allows students to create different enemy types by creating new EnemyResource files

## Just create a new EnemyResource .tres file with different stats, texture, and behavior

@export var enemy_data: EnemyResource

# Current stats (loaded from EnemyResource and scaled by wave)
var max_health: float = 50.0
var current_health: float = 50.0
var contact_damage: float = 10.0
var move_speed: float = 100.0
var detection_range: float = 1000.0
var xp_value: int = 10

# References
## Player reference - set by WaveSpawner when enemy is spawned
## Note: %Player doesn't work for runtime-instantiated nodes, so WaveSpawner sets this directly
var player: Player = null
var sprite: Node = null

# Contact damage cooldown
var damage_cooldown: float = 0.0
var damage_cooldown_time: float = 1.0

# XP drop scene
@export var xp_drop_scene: PackedScene


func _ready() -> void:
	# Add to enemies group for targeting
	add_to_group("enemies")

	# Set collision layers (Layer 2 = enemies)
	collision_layer = 2
	collision_mask = 1  # Collide with player

	# Get sprite node (could be Sprite2D or AnimatedSprite2D)
	sprite = get_node_or_null("Sprite2D")
	if not sprite:
		sprite = get_node_or_null("AnimatedSprite2D")

	# WaveSpawner will call load_from_resource() after _ready() runs
	# So we don't need to load anything here


## Load enemy stats from an EnemyResource with wave scaling
## Returns true if successfully loaded
func load_from_resource(resource: EnemyResource, wave_number: int) -> bool:
	if not resource:
		return false

	enemy_data = resource

	# Get scaled stats based on wave
	max_health = resource.get_scaled_health(wave_number)
	current_health = max_health
	contact_damage = resource.get_scaled_damage(wave_number)
	move_speed = resource.get_scaled_speed(wave_number)
	xp_value = resource.get_scaled_xp(wave_number)

	detection_range = resource.detection_range

	# Set visual (sprite is already set in _ready())
	if sprite:
		if resource.animated_frames and sprite is AnimatedSprite2D:
			sprite.sprite_frames = resource.animated_frames
			sprite.scale = Vector2(resource.sprite_scale, resource.sprite_scale)
			sprite.play("idle")
		elif resource.enemy_texture and sprite is Sprite2D:
			sprite.texture = resource.enemy_texture
			sprite.scale = Vector2(resource.sprite_scale, resource.sprite_scale)

	return true


func _physics_process(delta: float) -> void:
	if not player or not is_instance_valid(player):
		return

	# Update damage cooldown
	if damage_cooldown > 0:
		damage_cooldown -= delta

	# Check if player is in detection range
	var distance_to_player = global_position.distance_to(player.global_position)

	if distance_to_player <= detection_range:
		# Move toward player
		var direction_to_player = (player.global_position - global_position).normalized()

		# Apply separation from other enemies if enabled
		if enemy_data and enemy_data.uses_separation:
			direction_to_player = apply_separation(direction_to_player)

		velocity = direction_to_player * move_speed
		move_and_slide()

		# Flip sprite based on movement direction
		if sprite and direction_to_player.x != 0:
			if sprite is Sprite2D:
				sprite.flip_h = direction_to_player.x < 0
			elif sprite is AnimatedSprite2D:
				sprite.flip_h = direction_to_player.x < 0


## Apply separation force to avoid clustering
func apply_separation(current_direction: Vector2) -> Vector2:
	var separation_force = Vector2.ZERO
	var nearby_enemies = get_tree().get_nodes_in_group("enemies")

	for enemy in nearby_enemies:
		if enemy == self or not enemy is Node2D:
			continue

		var distance = global_position.distance_to(enemy.global_position)
		if distance < enemy_data.separation_distance and distance > 0:
			var away_vector = (global_position - enemy.global_position).normalized()
			separation_force += away_vector / distance

	# Blend current direction with separation force
	var final_direction = (current_direction + separation_force * 0.5).normalized()
	return final_direction


## Take damage from player weapons
## Returns true if this damage killed the enemy
func take_damage(amount: float) -> bool:
	current_health -= amount

	# Visual feedback (optional: flash sprite)
	if sprite:
		sprite.modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		if is_instance_valid(sprite):
			sprite.modulate = Color.WHITE

	if current_health <= 0:
		die()
		return true

	return false


## Handle enemy death
## Returns true if death was handled successfully
func die() -> bool:
	# Drop XP
	if xp_drop_scene and player:
		var xp_drop = xp_drop_scene.instantiate()
		xp_drop.xp_amount = xp_value
		xp_drop.global_position = global_position
		# Add to parent scene so it can access %Player unique name
		get_parent().add_child(xp_drop)

	# Remove enemy
	queue_free()
	return true


## Handle collision with player (contact damage)
func _on_body_entered(body: Node2D) -> void:
	if body is Player and damage_cooldown <= 0:
		body.take_damage(contact_damage)
		damage_cooldown = damage_cooldown_time
