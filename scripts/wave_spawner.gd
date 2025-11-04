extends Node2D
class_name WaveSpawner

## Manages enemy spawning in waves for Vampire Survivors-style gameplay
## Spawns enemies continuously with increasing difficulty
##
## TEACHING NOTE: This uses a template-based enemy system!
## - enemy_scene should point to scenes/enemies/enemy.tscn (generic template)
## - The template is instantiated, then configured using an EnemyResource
## - Students create new enemy types by creating new .tres resource files
## - No need to create new enemy scene files!

## Base enemy scene template (scenes/enemies/enemy.tscn)
@export var enemy_scene: PackedScene

## Available enemy types to spawn (configured via EnemyResource)
## The spawner will randomly select from available enemies based on:
## - unlock_wave: Only spawn enemies unlocked for current wave
## - spawn_weight: Higher weight = more common
## - credit_cost: More expensive enemies are stronger
@export var available_enemies: Array[EnemyResource] = []

@export var spawn_radius_min: float = 400.0
@export var spawn_radius_max: float = 600.0

## Credits system - spawner gains credits over time to spend on enemies
@export var base_credits_per_second: float = 20.0
@export var credit_gain_increase_per_wave: float = 5.0
@export var spawn_attempt_interval: float = 0.5  # Only try to spawn every X seconds

var current_wave: int = 1
var current_credits: float = 0.0
var spawn_attempt_timer: float = 0.0
@onready var player: Player = %Player

var enemies_spawned_this_wave: int = 0
var wave_start_time: float = 0.0

# Wave progression
var wave_duration: float = 60.0  # Each wave lasts 60 seconds


func _ready() -> void:
	wave_start_time = Time.get_ticks_msec() / 1000.0

	print("\n=== WAVE SPAWNER INITIALIZED ===")
	print("Starting credit gain: ", base_credits_per_second, " credits/second")
	print("Credit gain increase per wave: +", credit_gain_increase_per_wave, " credits/second")
	print("Available enemy types: ", available_enemies.size())
	for enemy in available_enemies:
		if enemy:
			print("  - ", enemy.enemy_name, " (Cost: ", enemy.credit_cost, ", Wave: ", enemy.unlock_wave, ")")


func _process(delta: float) -> void:
	if not player or not is_instance_valid(player):
		return

	# Accumulate credits over time
	var credits_per_second = get_current_credits_per_second()
	var credits_gained = credits_per_second * delta
	current_credits += credits_gained

	# Update spawn attempt timer
	spawn_attempt_timer -= delta

	# Only try to spawn on intervals (not every frame)
	if spawn_attempt_timer <= 0:
		attempt_spawn_enemy()
		spawn_attempt_timer = spawn_attempt_interval

	# Check for wave progression
	var time_elapsed = (Time.get_ticks_msec() / 1000.0) - wave_start_time
	if time_elapsed >= wave_duration * current_wave:
		advance_wave()


## Attempt to spawn an enemy if we have enough credits
## Returns true if an enemy was spawned
func attempt_spawn_enemy() -> bool:
	if not enemy_scene or not player:
		return false

	# Get available enemy types for current wave
	var available_for_wave = get_available_enemies_for_wave()

	if available_for_wave.is_empty():
		return false

	# Filter to only enemies we can afford
	var affordable_enemies = get_affordable_enemies(available_for_wave)

	if affordable_enemies.is_empty():
		return false

	# Pick random enemy based on spawn weight
	var chosen_enemy_resource = pick_weighted_random_enemy(affordable_enemies)

	if not chosen_enemy_resource:
		return false

	# Check if we still have enough credits (double check)
	if current_credits < chosen_enemy_resource.credit_cost:
		return false

	# Deduct credits
	current_credits -= chosen_enemy_resource.credit_cost

	# Calculate spawn position (random point in ring around player)
	var angle = randf() * TAU
	var distance = randf_range(spawn_radius_min, spawn_radius_max)
	var spawn_offset = Vector2(cos(angle), sin(angle)) * distance
	var spawn_pos = player.global_position + spawn_offset

	# Instance enemy
	var enemy_instance = enemy_scene.instantiate()
	enemy_instance.global_position = spawn_pos

	# Add enemy to the scene tree FIRST so @onready variables initialize
	get_parent().add_child(enemy_instance)

	# Set the player reference directly (since %Player doesn't work for runtime-instantiated nodes)
	if enemy_instance.has_method("set") and player:
		enemy_instance.player = player

	# Now load the chosen resource with wave scaling (after _ready() has run)
	if enemy_instance.has_method("load_from_resource"):
		enemy_instance.load_from_resource(chosen_enemy_resource, current_wave)

	enemies_spawned_this_wave += 1
	return true


## Progress to next wave
## Returns true when wave is advanced
func advance_wave() -> bool:
	current_wave += 1

	print("\n========== WAVE " + str(current_wave) + " ==========")
	print("Enemies spawned last wave: ", enemies_spawned_this_wave)
	print("Enemy stats increased by ", (current_wave - 1) * 15, "%")
	print("Credit gain rate: ", get_current_credits_per_second(), " credits/second")
	print("Current credits: ", snappedf(current_credits, 0.1))

	enemies_spawned_this_wave = 0

	return true


## Get the current credit gain rate based on wave number
func get_current_credits_per_second() -> float:
	return base_credits_per_second + (current_wave - 1) * credit_gain_increase_per_wave


## Get the cheapest enemy cost from a list of enemies
func get_cheapest_enemy_cost(enemies: Array[EnemyResource]) -> int:
	if enemies.is_empty():
		return 0

	var cheapest = enemies[0].credit_cost
	for enemy in enemies:
		if enemy.credit_cost < cheapest:
			cheapest = enemy.credit_cost

	return cheapest


## Get list of enemies we can afford with current credits
func get_affordable_enemies(enemies: Array[EnemyResource]) -> Array[EnemyResource]:
	var affordable: Array[EnemyResource] = []

	for enemy in enemies:
		if enemy and enemy.credit_cost <= current_credits:
			affordable.append(enemy)

	return affordable


## Get list of enemies available for the current wave
## Filters based on unlock_wave property
func get_available_enemies_for_wave() -> Array[EnemyResource]:
	var available: Array[EnemyResource] = []

	for enemy_resource in available_enemies:
		if enemy_resource and enemy_resource.unlock_wave <= current_wave:
			available.append(enemy_resource)

	return available


## Pick a random enemy from the list based on spawn_weight
## Higher weight = more likely to be chosen
func pick_weighted_random_enemy(enemies: Array[EnemyResource]) -> EnemyResource:
	if enemies.is_empty():
		return null

	# Calculate total weight
	var total_weight: int = 0
	for enemy in enemies:
		total_weight += enemy.spawn_weight

	# Pick random value in weight range
	var random_value = randi() % total_weight

	# Find which enemy this corresponds to
	var cumulative_weight: int = 0
	for enemy in enemies:
		cumulative_weight += enemy.spawn_weight
		if random_value < cumulative_weight:
			return enemy

	# Fallback (should never reach here)
	return enemies[0]
