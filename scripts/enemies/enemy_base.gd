extends CharacterBody2D
class_name EnemyBase

## Base class for all enemies
## Enemies use EnemyResource to load their stats and behavior
## This allows students to create different enemy types by just changing the Resource

@export var enemy_data: EnemyResource

# Current stats (loaded from EnemyResource and scaled by wave)
var max_health: float = 50.0
var current_health: float = 50.0
var contact_damage: float = 10.0
var move_speed: float = 100.0
var detection_range: float = 1000.0
var xp_value: int = 10

# References
@onready var player: Player = %Player
var sprite: Node = null

# Contact damage cooldown
var damage_cooldown: float = 0.0
var damage_cooldown_time: float = 1.0

# XP drop scene
@export var xp_drop_scene: PackedScene

# Material drop scene
@export var material_drop_scene: PackedScene

# Material drop scenes (loaded at runtime)
var material_scenes: Dictionary = {}


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

	# Load stats from EnemyResource
	if enemy_data:
		load_from_resource(enemy_data, 1)  # Wave 1 by default


## Load enemy stats from an EnemyResource with wave scaling
func load_from_resource(resource: EnemyResource, wave_number: int) -> void:
	enemy_data = resource

	# Get scaled stats based on wave
	var scaled_stats = resource.get_scaled_stats(wave_number)

	max_health = scaled_stats["max_health"]
	current_health = max_health
	contact_damage = scaled_stats["contact_damage"]
	move_speed = scaled_stats["move_speed"]
	xp_value = scaled_stats["xp_value"]

	detection_range = resource.detection_range

	# Set visual
	if sprite:
		if resource.animated_frames and sprite is AnimatedSprite2D:
			sprite.sprite_frames = resource.animated_frames
			sprite.play("idle")
		elif resource.enemy_texture and sprite is Sprite2D:
			sprite.texture = resource.enemy_texture


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
func take_damage(amount: float) -> void:
	current_health -= amount

	# Visual feedback (optional: flash sprite)
	if sprite:
		sprite.modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		if is_instance_valid(sprite):
			sprite.modulate = Color.WHITE

	if current_health <= 0:
		die()


## Handle enemy death
func die() -> void:
	# Drop XP
	if xp_drop_scene and player:
		var xp_drop = xp_drop_scene.instantiate()
		xp_drop.xp_amount = xp_value
		xp_drop.global_position = global_position
		get_tree().root.add_child(xp_drop)

	# Drop materials
	if enemy_data:
		var drops = enemy_data.roll_drops()
		for material_id in drops:
			spawn_material_drop(material_id)

	# Remove enemy
	queue_free()


## Spawn a material drop
func spawn_material_drop(material_id: String) -> void:
	if not material_drop_scene:
		print("Enemy dropped material: " + material_id + " (no scene configured)")
		return

	var drop = material_drop_scene.instantiate()
	drop.material_id = material_id
	drop.amount = 1
	drop.global_position = global_position
	get_tree().root.add_child(drop)

	print("Enemy dropped material: " + material_id)


## Handle collision with player (contact damage)
func _on_body_entered(body: Node2D) -> void:
	if body is Player and damage_cooldown <= 0:
		body.take_damage(contact_damage)
		damage_cooldown = damage_cooldown_time
