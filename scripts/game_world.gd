extends Node2D
class_name GameWorld

## ============================================================================
## GAME WORLD - Main game scene controller
## ============================================================================
##
## WHAT THIS SCRIPT DOES:
## This is the main controller for the game. It:
## - Manages the overall game scene
## - Connects to player signals (death, level up)
## - Provides debug commands for testing
## - Handles game over state
##
## This script works with:
## - scenes/arena.tscn (the main game scene)
## - scripts/player.gd (player character)
## - scripts/wave_spawner.gd (enemy spawning)
##
## ============================================================================
## DEBUG COMMANDS (for testing):
## ============================================================================
##
## SPACE - Print debug info (health, level, XP, available methods)
## ENTER - Gain 50 XP instantly (for testing level ups)
## ESC - Quit game
##
## ============================================================================
## COMMON MODIFICATIONS:
## ============================================================================
##
## Add game restart:
##   - Find: func _on_player_died()
##   - Add: get_tree().reload_current_scene()
##
## Add main menu:
##   - Create menu scene
##   - Switch to it on player death
##
## Add score tracking:
##   - Count kills, track time survived
##   - Display on game over screen
##
## Add pause menu:
##   - Detect pause input
##   - Show pause UI, set get_tree().paused = true
##
## ============================================================================

# Player reference - our main character
@onready var player = $Player


func _ready():
	# Connect to player death signal
	if player:
		player.player_died.connect(_on_player_died)

	print("=== GAME WORLD LOADED ===")
	print("Use arrow keys or WASD to move the player")
	print("Enemies will spawn automatically!")
	print("Press SPACE for debug info")
	print("Press ENTER to gain experience (testing)")
	print("========================")

func _unhandled_input(event):
	# Debug commands for testing character systems
	if event.is_action_pressed("ui_select"):  # Space key
		print("=== DEBUG INFO ===")
		print("Player Name: " + player.character_name)
		print("Player Health: " + str(player.current_health) + "/" + str(player.max_health))
		print("Player Level: " + str(player.level))
		print("Player Experience: " + str(player.current_xp) + "/" + str(player.xp_to_next_level))

		# Check which methods exist
		if player.has_method("take_damage"):
			print("✅ Player has take_damage() method")
		else:
			print("❌ Player missing take_damage() method")

		if player.has_method("heal"):
			print("✅ Player has heal() method")
		else:
			print("❌ Player missing heal() method")

		if player.has_method("level_up_character"):
			print("✅ Player has level_up_character() method")
		else:
			print("❌ Player missing level_up_character() method")

		print("==================")
	
	# Secret debug command for testing experience
	if event.is_action_pressed("ui_accept"):  # Enter key
		print("🧪 DEBUG: Giving player 50 experience")
		player.gain_experience(50)


## Handle player death
func _on_player_died() -> void:
	print("💀 GAME OVER 💀")
	print("Press ESC to quit")
	get_tree().paused = true
