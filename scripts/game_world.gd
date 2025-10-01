extends Node2D
class_name GameWorld

# Player reference - our main character
@onready var player = $Player

# Test objects for character methods
@onready var spike = $Spike
@onready var health_potion = $HealthPotion

func _ready():
	pass



# TODO: Add game management methods here (Future lessons)
# - spawn_enemy()
# - handle_combat()  
# - check_game_over()
