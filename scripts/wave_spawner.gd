extends Node2D
class_name WaveSpawner

## Manages enemy spawning in waves for Vampire Survivors-style gameplay
## Spawns enemies continuously with increasing difficulty

@export var enemy_scene: PackedScene
@export var spawn_radius_min: float = 400.0
@export var spawn_radius_max: float = 600.0
@export var spawn_interval: float = 2.0

var current_wave: int = 1
var spawn_timer: float = 0.0
@onready var player: Player = %Player


var enemies_spawned_this_wave: int = 0
var wave_start_time: float = 0.0

# Wave progression
var wave_duration: float = 60.0  # Each wave lasts 60 seconds
var enemies_per_wave_base: int = 50


func _ready() -> void:
	

	wave_start_time = Time.get_ticks_msec() / 1000.0


func _process(delta: float) -> void:
	if not player or not is_instance_valid(player):
		return

	# Update spawn timer
	spawn_timer -= delta

	if spawn_timer <= 0:
		spawn_enemy()
		spawn_timer = spawn_interval / get_wave_spawn_speed_multiplier()

	# Check for wave progression
	var time_elapsed = (Time.get_ticks_msec() / 1000.0) - wave_start_time
	if time_elapsed >= wave_duration * current_wave:
		advance_wave()


## Spawn a single enemy at a random position around the player
## Returns true if enemy was spawned successfully
func spawn_enemy() -> bool:
	if not enemy_scene or not player:
		return false

	# Calculate spawn position (random point in ring around player)
	var angle = randf() * TAU
	#pick a random float between min and max spawn radius
	var distance = randf_range(spawn_radius_min, spawn_radius_max)
	
	var spawn_offset = Vector2(cos(angle), sin(angle)) * distance
	var spawn_pos = player.global_position + spawn_offset

	# Instance enemy
	var enemy_instance = enemy_scene.instantiate()

	# If enemy uses EnemyResource, load it with wave scaling
	if enemy_instance.has_method("load_from_resource") and enemy_instance.enemy_data:
		enemy_instance.load_from_resource(enemy_instance.enemy_data, current_wave)

	enemy_instance.global_position = spawn_pos
	get_tree().root.add_child(enemy_instance)

	enemies_spawned_this_wave += 1
	return true


## Progress to next wave
## Returns true when wave is advanced
func advance_wave() -> bool:
	current_wave += 1
	enemies_spawned_this_wave = 0

	print("========== WAVE " + str(current_wave) + " ==========")
	print("Enemy health and damage increased!")
	print("Spawn rate increased!")

	return true


## Get spawn speed multiplier based on current wave
func get_wave_spawn_speed_multiplier() -> float:
	return 1.0 + (current_wave - 1) * 0.2  # 20% faster each wave
