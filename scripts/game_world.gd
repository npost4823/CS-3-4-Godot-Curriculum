extends Node2D
class_name GameWorld

# Player reference - our main character
@onready var player = $Player

# System references
# var inventory: InventorySystem = null

func _ready():
	# Set global reference so other systems can find us
	Global.game_world = self

	# Get inventory system reference (commented out - inventory system not currently active)
	# inventory = get_node_or_null("InventorySystem")

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
		print("Player Experience: " + str(player.experience_points))
		print("Player Damage: " + str(player.damage))
		
		# Check which methods exist
		if player.has_method("take_damage"):
			print("✅ Player has take_damage() method")
		else:
			print("❌ Player missing take_damage() method")
			
		if player.has_method("heal"):
			print("✅ Player has heal() method")  
		else:
			print("❌ Player missing heal() method")
			
		if player.has_method("level_up"):
			print("✅ Player has level_up() method")
		else:
			print("❌ Player missing level_up() method")
			
		print("==================")
	
	# Secret debug command for testing experience
	if event.is_action_pressed("ui_accept"):  # Enter key
		print("🧪 DEBUG: Giving player 50 experience")
		player.gain_experience(50)

# TODO: Add game management methods here (Future lessons)
# - spawn_enemy()
# - handle_combat()  
# - check_game_over()
