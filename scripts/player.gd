extends CharacterBody2D
class_name Player


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Movement - Controls how fast the player moves
@export var move_speed: float = 200.0


var facing: Vector2 = Vector2.ZERO

# Character Identity
@export var character_name: String = "Survivor"

# Health System
@export var max_health: float = 100.0
var current_health: float = 100.0

# Level and Experience
var level: int = 1
var current_xp: float = 0.0
var xp_to_next_level: float = 100.0


# Signals for UI updates
signal health_changed(new_health: float, max_health: float)
signal xp_changed(current_xp: float, xp_needed: float)
signal level_up(new_level: int)
signal player_died

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit(0)


func _ready():
	current_health = max_health

	# Set collision layers (Layer 1 = player)
	collision_layer = 1
	collision_mask = 2 | 8  # Collide with enemies (layer 2) and XP drops (layer 8)

func _physics_process(_delta):
	handle_movement()

func handle_movement():
	# Get input direction from arrow keys
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	handle_sprite(direction)
	
	# Normalize diagonal movement to prevent speed boost
	if direction.length() > 0:
		direction = direction.normalized()
	
	# Apply movement using Godot's built-in physics
	velocity = direction * move_speed
	move_and_slide()

## Update sprite animation based on movement direction
## Handles 4-directional sprites with idle and walk states
func handle_sprite(direction: Vector2) -> void:
	var prefix: String = "walk"
	if direction == Vector2.ZERO:
		prefix = "idle"
	else:
		facing = direction

	if facing.y > 0:
		animated_sprite.play(prefix + "_forward")
	elif facing.y < 0:
		animated_sprite.play(prefix + "_backward")
	elif facing.x < 0:
		animated_sprite.play(prefix + "_side")
		animated_sprite.flip_h = true
	elif facing.x > 0:
		animated_sprite.play(prefix + "_side")
		animated_sprite.flip_h = false

# ========== CHARACTER METHODS ==========

## Take damage from enemies or hazards
## Returns true if this damage killed the player
func take_damage(amount: float) -> bool:
	current_health -= amount
	current_health = max(0, current_health)
	health_changed.emit(current_health, max_health)

	if current_health <= 0:
		die()
		return true

	return false


## Heal the player
## Returns true if healing was applied (false if already at full health)
func heal(amount: float) -> bool:
	if current_health >= max_health:
		return false

	current_health += amount
	current_health = min(max_health, current_health)
	health_changed.emit(current_health, max_health)

	return true


## Gain experience points
## Returns true if this XP gain caused a level up
func gain_experience(amount: float) -> bool:
	current_xp += amount
	xp_changed.emit(current_xp, xp_to_next_level)

	# Check if leveled up
	var did_level_up = false
	while current_xp >= xp_to_next_level:
		level_up_character()
		did_level_up = true

	return did_level_up


## Level up the character
## Returns true on successful level up
func level_up_character() -> bool:
	level += 1
	current_xp -= xp_to_next_level
	xp_to_next_level = calculate_xp_for_next_level()

	# Heal on level up
	current_health = max_health
	health_changed.emit(current_health, max_health)

	print("🎉 LEVEL UP! Now level " + str(level))
	print("XP to next level: " + str(xp_to_next_level))

	# Emit signal to show upgrade selection UI
	level_up.emit(level)

	return true


## Calculate XP needed for the next level (exponential scaling)
func calculate_xp_for_next_level() -> float:
	return 100.0 + (level - 1) * 50.0  # 100, 150, 200, 250, etc.


## Handle player death
## Returns true when death is handled
func die() -> bool:
	print(character_name + " has died!")
	player_died.emit()
	# Disable player controls
	set_physics_process(false)
	# Hide or play death animation
	visible = false

	return true


# ========== STAT UPGRADE METHODS (Called from UI) ==========


## Upgrade max health
## Returns true on successful upgrade
func upgrade_health(amount: float) -> bool:
	max_health += amount
	current_health += amount  # Also heal when upgrading
	health_changed.emit(current_health, max_health)
	return true


## Upgrade movement speed
## Returns true on successful upgrade
func upgrade_speed(amount: float) -> bool:
	move_speed += amount
	return true
