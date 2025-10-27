extends Node2D
class_name WeaponSystem

## Handles automatic weapon firing for the player
## This node is a child of the player and rotates to face enemies
## It loads weapon data from ProjectileWeaponResource files

@export var equipped_weapon: ProjectileWeaponResource
@export var projectile_scene: PackedScene

@onready var weapon_sprite: Sprite2D = $WeaponSprite
@onready var fire_point: Marker2D = $FirePoint

var fire_cooldown: float = 0.0
var nearest_enemy: Node2D = null


func _ready() -> void:
	# Load default weapon if equipped
	if equipped_weapon:
		_update_weapon_visuals()


func _process(delta: float) -> void:
	# Update fire cooldown timer
	if fire_cooldown > 0:
		fire_cooldown -= delta

	# Find nearest enemy
	nearest_enemy = _find_nearest_enemy()

	# Rotate to face nearest enemy
	if nearest_enemy:
		var direction_to_enemy = (nearest_enemy.global_position - global_position).normalized()
		rotation = direction_to_enemy.angle()

		# Flip sprite if aiming left
		if direction_to_enemy.x < 0:
			weapon_sprite.flip_v = true
		else:
			weapon_sprite.flip_v = false

		# Auto-fire if cooldown is ready
		if fire_cooldown <= 0 and equipped_weapon:
			_fire_weapon(direction_to_enemy)


## Find the closest enemy to the player
func _find_nearest_enemy() -> Node2D:
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.size() == 0:
		return null

	var closest_enemy: Node2D = null
	var closest_distance: float = INF

	for enemy in enemies:
		if enemy is Node2D:
			var distance = global_position.distance_to(enemy.global_position)
			if distance < closest_distance:
				closest_distance = distance
				closest_enemy = enemy

	return closest_enemy


## Fire the equipped weapon
func _fire_weapon(direction: Vector2) -> void:
	if not equipped_weapon or not projectile_scene:
		return

	# Calculate spread based on accuracy
	var spread_rad = deg_to_rad(equipped_weapon.accuracy_spread)

	# Fire multiple projectiles if weapon has projectile_count > 1
	for i in range(equipped_weapon.projectile_count):
		var projectile_instance = projectile_scene.instantiate()

		# Calculate direction with spread
		var angle_offset = 0.0
		if equipped_weapon.projectile_count > 1:
			# Spread projectiles evenly
			var total_spread = deg_to_rad(equipped_weapon.spread_angle)
			angle_offset = -total_spread / 2.0 + (total_spread / (equipped_weapon.projectile_count - 1)) * i
		else:
			# Single projectile gets random spread
			angle_offset = randf_range(-spread_rad, spread_rad)

		var final_direction = direction.rotated(angle_offset)

		# Setup projectile
		projectile_instance.direction = final_direction
		projectile_instance.global_position = fire_point.global_position

		# Pass weapon data to projectile
		var projectile_data = equipped_weapon.get_projectile_data()
		projectile_instance.setup(projectile_data)

		# Add to scene
		get_tree().root.add_child(projectile_instance)

	# Reset cooldown
	fire_cooldown = equipped_weapon.get_fire_cooldown()


## Equip a new weapon by loading a ProjectileWeaponResource
func equip_weapon(weapon: ProjectileWeaponResource) -> void:
	equipped_weapon = weapon
	_update_weapon_visuals()
	fire_cooldown = 0.0  # Reset cooldown when switching weapons


## Update the visual representation of the weapon
func _update_weapon_visuals() -> void:
	if equipped_weapon and weapon_sprite:
		weapon_sprite.texture = equipped_weapon.weapon_sprite
		weapon_sprite.offset = equipped_weapon.hold_offset
